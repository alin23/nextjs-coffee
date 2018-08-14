import { all, apply, call, put, select, take } from 'redux-saga/effects'

import Router from 'next/router'

import { removeAuthTokenCookie, setAuthTokenCookie } from '~/lib/cookie'

import AuthActions from '~/redux/auth'


resetApolloStore = (apollo) ->
    yield call([apollo, apollo.resetStore])

setToken = (apollo, { token }) ->
    if not token?
        yield call(removeAuthTokenCookie)
    else
        yield call(setAuthTokenCookie, token)
    yield call([apollo, apollo.resetStore])
    Router.push('/')

export default {
    resetApolloStore
    setToken
}
