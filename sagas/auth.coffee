import { all, call, put, select, take } from 'redux-saga/effects'

import { setAuthTokenCookie } from '~/lib/cookie'

import AuthActions from '~/redux/auth'


export authenticate = (api, apollo, { username, password }) ->
    res = yield call(api.authenticate, username, password)
    unless res.ok
        yield put AuthActions.finishAuthentication(ok = false, user = null)
        return

    user = res.data
    setAuthTokenCookie(user.token)
    yield put AuthActions.finishAuthentication(ok = true, user = user)
    apollo.resetStore()
    return
