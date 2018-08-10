import React from 'react'
import { ApolloProvider, getDataFromTree } from 'react-apollo'

import fetch from 'isomorphic-fetch'
import _ from 'lodash'
import getConfig from 'next/config'
import Head from 'next/head'

import { InMemoryCache } from 'apollo-cache-inmemory'
import { ReduxCache } from 'apollo-cache-redux'
import { ApolloClient } from 'apollo-client'
import { HttpLink } from 'apollo-link-http'

import Raven from '~/lib/raven'

{ serverRuntimeConfig, publicRuntimeConfig } = getConfig()
apolloClient = null

# Polyfill fetch() on the server (used by apollo-client)
if not process.browser
    global.fetch = fetch

createDefaultCache = () -> new InMemoryCache()
createReduxCache = (store) -> new ReduxCache({ store })

create = (apolloConfig, initialState, reduxStore) ->
    createCache = apolloConfig.createCache ? if reduxStore?
        () -> createReduxCache(reduxStore)
    else
        createDefaultCache

    config = {
        connectToDevTools: process.browser
        # Disables forceFetch on the server (so queries are only run once)
        ssrMode: not process.browser
        cache: createCache().restore(initialState or {})
        apolloConfig...
    }

    delete config.createCache

    return new ApolloClient(config)


initApollo = (apolloConfig, initialState, { store, ctx... } = {}) ->
    if _.isFunction(apolloConfig)
        apolloConfig = apolloConfig(ctx)

    # Make sure to create a new client for every server-side request so that data
    # isn't shared between connections (which would be bad)
    if not process.browser
        return create(apolloConfig, initialState, store)

    # Reuse client on the client-side
    apolloClient ?= create(apolloConfig, initialState, store)

    return apolloClient

# Gets the display name of a JSX component for dev tools
getComponentDisplayName = (Component) ->
    return Component.displayName or Component.name or 'Unknown'


withData = (apolloConfig) ->
    (ComposedComponent) ->
        class WithData extends React.Component
            @displayName: "WithData(#{ getComponentDisplayName(ComposedComponent) })"

            @getInitialProps: ({ Component, router, ctx }) ->
                serverState = { apollo: { } }

                # Evaluate the composed component's getInitialProps()
                composedInitialProps = {}
                if ComposedComponent.getInitialProps
                    composedInitialProps = await ComposedComponent.getInitialProps(
                        { Component, router, ctx }
                    )

                # Run all GraphQL queries in the component tree
                # and extract the resulting data
                if not process.browser
                    apollo = initApollo(apolloConfig, null, ctx)

                    # Provide the `url` prop data in case a GraphQL query uses it
                    url = { query: ctx.query, pathname: ctx.pathname }

                    try
                        # Run all GraphQL queries
                        await getDataFromTree(
                            <ApolloProvider client={ apollo }>
                                <ComposedComponent
                                    url={ url }
                                    ctx={ ctx }
                                    Component={ Component }
                                    router={ router }
                                    store={ ctx.store }
                                    { composedInitialProps... }
                                />
                            </ApolloProvider>,
                            {
                                router:
                                    asPath: ctx.asPath
                                    pathname: ctx.pathname
                                    query: ctx.query
                            }
                        )
                    catch error
                        console.error(error)
                        Raven.captureException(error)
                        # Prevent Apollo Client GraphQL errors from crashing SSR.
                        # Handle them in components via the data.error prop:
                        # http:#dev.apollodata.com/react/api-queries.html#graphql-query-data-error

                    # getDataFromTree does not call componentWillUnmount
                    # head side effect therefore need to be cleared manually
                    Head.rewind()

                    # Extract query data from the Apollo store
                    serverState =
                        apollo:
                            data: apollo.cache.extract()

                return {
                    serverState
                    composedInitialProps...
                }


            constructor: (props) ->
                super(props)
                @apollo = initApollo(
                    apolloConfig
                    @props.serverState?.apollo?.data
                )

            render: ->
                <ApolloProvider client={ @apollo }>
                    <ComposedComponent { @props... } />
                </ApolloProvider>

config = ({ isServer = false, req } = {}) ->
    link: new HttpLink(
        if isServer
            uri: publicRuntimeConfig.localGraphQlUrl
            credentials: 'same-origin'
            headers:
                cookie: req?.headers?.cookie
        else
            uri: publicRuntimeConfig.remoteGraphQlUrl
            credentials: 'same-origin'
    )

export getApolloClient = (store) ->
    apolloClient ? initApollo(config, null, { store })

export default withData(config)
