import { all, takeEvery, takeLatest } from 'redux-saga/effects'

import { Types as AuthTypes } from '~/redux/auth'
import { Types as StartupTypes } from '~/redux/startup'

import API from '~/services/api'
import { getApolloClient } from '~/services/apollo'

import { authenticate } from './auth'
import startup from './startup'


export default getRootSaga = (ctx) ->
    api = API.create(ctx)
    apollo = getApolloClient(ctx.store)
    return () ->
        yield all([
            takeLatest(StartupTypes.STARTUP, startup)
            takeLatest(AuthTypes.AUTHENTICATE, authenticate, api, apollo)
        ])
