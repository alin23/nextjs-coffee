import { applyMiddleware, compose, createStore } from 'redux'
import createSagaMiddleware from 'redux-saga'

import { reduxBatch } from '@manaflair/redux-batch'

import createRavenMiddleware from 'raven-for-redux'

import Raven from '~/lib/raven'

import config from '~/config'

configureStore = (rootReducer, getRootSaga, initialState, ctx) ->
    isClient = not ctx.isServer

    createAppropriateStore = createStore
    middleware = []
    sagaMonitor = null
    if isClient and config.DEV
        require '~/services/reactotron'
        if console.tron.createStore?
            createAppropriateStore = console.tron.createStore
        if console.tron.createSagaMonitor?
            sagaMonitor = console.tron.createSagaMonitor()
    else
        console.tron =
            log: console.log
            warn: console.warn
            error: console.error
            display: console.log
            image: console.log

    sagaMiddleware = createSagaMiddleware({
        sagaMonitor
        onError: (err) ->
            console.error(err)
            Raven.captureException(err)
    })
    middleware.push(sagaMiddleware)

    ravenMiddleware = createRavenMiddleware(Raven, {})
    middleware.push(ravenMiddleware)

    enhancers = [
        reduxBatch
        applyMiddleware(middleware...)
        reduxBatch
    ]

    store = createAppropriateStore(rootReducer, initialState, compose(enhancers...))

    if isClient and sagaMiddleware?
        sagaMiddleware.run(getRootSaga({ ctx..., store }))

    store

export default configureStore
