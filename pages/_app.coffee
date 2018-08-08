import React from "react"
import { Provider, connect } from 'react-redux'

import _ from 'lodash'
import withRedux from "next-redux-wrapper"
import Head from 'next/head'
import Router from 'next/router'

import App, { Container } from "next/app"

import Layout from '~/components/layout'

import createStore from '~/redux'
import StartupActions from '~/redux/startup'
import UIActions from '~/redux/ui'

import API from '~/services/api'
import withData from '~/services/apollo'

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
        api = API.create({ isServer, store, query, res, req, cache })

        ctx = { store, query, res, req, isServer, api, ctx... }
        pageProps = {}
        if Component.getInitialProps
            pageProps = await Component.getInitialProps(ctx) ? {}

        if pageProps.error?.problem?
            { problem, data, sentryEventId } = pageProps.error
            pageProps = {
                pageProps...
                error: { problem, data, sentryEventId }
            }

        fetchedProps = {
            (pageProps.fetched ? {})...
        }

        initialProps = {
            config.DEFAULT_PAGE_PROPS...
            (config.PAGE_PROPS[router.route] ? {})...
            (pageProps.initial ? {})...
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
        })

    componendDidCatch: (error, info) ->
        Raven.captureException(error, { extra: info })

    componentWillUnmount: ->
        window.removeEventListener('resize', @detectMobileDeferred)

    componentDidMount: ->
        @detectMobile()
        window.addEventListener('resize', @detectMobileDeferred)
        @props.setUIState(@props.initial)

        Router.events.on('routeChangeComplete', @syncUIStateBound)

        @props.startup()

    render: ->
        { Component, store, props... } = @props
        defaultPageProps = config.DEFAULT_PAGE_PROPS
        title = (
            props.title ?
            props.initial?.title ?
            defaultPageProps.title)
        themeColor = "#{
            props.themeColor ?
            props.initial?.themeColor ?
            defaultPageProps.themeColor }"
        description = (
            props.description ?
            props.initial?.description ?
            defaultPageProps.description)

        <AsyncMode>
            <Container>
                <Provider store={ store }>
                    <Layout>
                        <Head>
                            <title>{ title }</title>
                            <meta
                                name="description"
                                content={ description } />
                            <meta
                                name="theme-color"
                                content={ themeColor } />
                            <meta
                                name="msapplication-TileColor"
                                content={ themeColor } />
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

export default withData(
    withRedux(
        createStore
        debug: config.REDUX_DEBUG
)(connect(mapStateToProps, mapDispatchToProps)(MyApp)))
