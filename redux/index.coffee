import { combineReducers } from 'redux'
import undoable, { includeAction } from 'redux-undo'

import { parse } from 'url'

import Router from 'next/router'

import { apolloReducer } from 'apollo-cache-redux'

import { getAuthTokenCookie } from '~/lib/cookie'

import getRootSaga from '~/sagas'

import config from '~/config'

import configureStore from './store'


createStore = (initialState = {}, ctx = {}) ->
    rootReducer = combineReducers(
        apollo: apolloReducer
        auth: require('./auth').reducer
        startup: require('./startup').reducer
        ui: require('./ui').reducer
    )

    pathname = if ctx?.isServer
        parse(ctx.req.url).pathname
    else
        Router.pathname

    initialState = {
        initialState...
        auth: {
            token: getAuthTokenCookie(ctx.req)
        }
        ui: {
            config.DEFAULT_PAGE_PROPS...
            (config.PAGE_PROPS[pathname] ? {})...
        }
    }
    configureStore(rootReducer, getRootSaga, initialState, ctx)

export default createStore
