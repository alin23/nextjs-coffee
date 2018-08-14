import React from "react"
import { Provider, connect } from 'react-redux'

import _ from 'lodash'
import Head from 'next/head'
import Router from 'next/router'

import App, { Container } from "next/app"

import Layout from '~/components/layout'

import { getAuthTokenCookie } from '~/lib/cookie'

import createStore from '~/redux'
import StartupActions from '~/redux/startup'
import UIActions from '~/redux/ui'

import API from '~/services/api'
import withData from '~/services/apollo'
import withRedux from '~/services/redux'

import colors from '~/styles/colors'

import config from '~/config'

PATHNAME_PATTERN = /\/[^?'#']*/

AsyncMode = React.unstable_AsyncMode

class MyApp extends App
    constructor: (props) ->
        super props
        @syncUIStateBound = @syncUIState.bind(this)
        @detectMobileDeferred = _.debounce(
            (() => @detectMobile()),
            config.POLLING.windowResize)

    @getInitialProps: ({ Component, router, ctx }) ->
        { store, query, res, req, ctx... } = ctx
        isServer = req?
        cache = if isServer then req?.cache else null
        api = new API({ isServer, store, query, res, req, cache })

        ctx = { store, query, res, req, isServer, api, ctx... }
        pageProps = {}
        if Component.getInitialProps
            pageProps = await Component.getInitialProps(ctx) ? {}

        if isServer
            pageProps.authToken = getAuthTokenCookie(req)

        if pageProps.error?.problem?
            pageProps.error = {
                problem: pageProps.error.problem,
                data: pageProps.error.data,
                sentryEventId: pageProps.error.sentryEventId
            }

        fetchedProps = {
            (pageProps.fetched ? {})...
        }

        initialProps = {
            config.DEFAULT_PAGE_PROPS...
            (config.PAGE_PROPS[router.route] ? {})...
            (pageProps.initial ? {})...
            pathname: router.pathname
        }

        return {
            pageProps...
            fetched: fetchedProps
            initial: initialProps
        }

    detectMobile: ->
        @props.batchActions([
            UIActions.setState(
                windowWidth: window.innerWidth
                mobile: window.innerWidth <= config.WIDTH.mobile
                mediumScreen: window.innerWidth <= config.WIDTH.medium
            )
        ])

    syncUIState: (url) ->
        pathname = url.match(PATHNAME_PATTERN)?[0]
        pageProps = config.PAGE_PROPS[pathname] ? {}
        @props.setUIState({
            config.DEFAULT_PAGE_PROPS...
            pageProps...
            pathname
        })

    componendDidCatch: (error, info) ->
        Raven.captureException(error, { extra: info })

    componentWillUnmount: ->
        window.removeEventListener('resize', @detectMobileDeferred)

    componentDidMount: ->
        @detectMobile()
        window.addEventListener('resize', @detectMobileDeferred)

        Router.events.on('routeChangeComplete', @syncUIStateBound)

        @props.startup()

    render: ->
        { Component, store, props... } = @props
        <AsyncMode>
            <Container>
                <Provider store={ store }>
                    <Layout>
                        <Head>
                            <title>{ props.title }</title>
                            <meta
                                name="description"
                                content={ props.description } />
                            <meta
                                name="theme-color"
                                content={ props.themeColor } />
                            <meta
                                name="msapplication-TileColor"
                                content={ props.themeColor } />
                        </Head>
                        <Component { props... } />
                    </Layout>
                </Provider>
            </Container>
        </AsyncMode>

mapStateToProps = ({ ui }) ->
    description: ui.description
    title: ui.title
    themeColor: ui.themeColor

mapDispatchToProps = (dispatch) ->
    batchActions: (actions) -> dispatch(actions)
    setUIState: (ui) -> dispatch(UIActions.setState(ui))
    startup: () -> dispatch(StartupActions.startup())

ConnectedApp = connect(mapStateToProps, mapDispatchToProps)(MyApp)
ApolloApp = withData(ConnectedApp)
ApolloReduxApp = withRedux(createStore, debug: config.REDUX_DEBUG)(ApolloApp)

export default ApolloReduxApp
