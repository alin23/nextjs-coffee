import { all, takeEvery, takeLatest } from "redux-saga/effects"

import { Types as AuthTypes } from "~/redux/auth"
import { Types as StartupTypes } from "~/redux/startup"

import API from "~/services/api"
import { getApolloClient } from "~/services/apollo"

import AuthSaga from "./auth"
import startup from "./startup"

export default getRootSaga = (ctx) ->
    api = new API(ctx)
    apollo = getApolloClient(ctx.store)
    return () ->
        yield all([
            takeLatest(StartupTypes.STARTUP, startup)
            takeLatest(AuthTypes.RESET_APOLLO_STORE, AuthSaga.resetApolloStore, apollo)
            takeLatest(AuthTypes.SET_TOKEN, AuthSaga.setToken, apollo)
        ])
