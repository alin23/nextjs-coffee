import { all, takeEvery, takeLatest } from 'redux-saga/effects'

import { StartupTypes } from '~/redux/startup'

import API from '~/services/api'

import startup from './startup'


export default getRootSaga = (ctx) ->
    api = API.create(ctx)
    return () ->
        yield all([
            takeLatest(StartupTypes.STARTUP, startup)
        ])
