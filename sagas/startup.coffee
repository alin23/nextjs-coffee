import { all, call, put, select, take } from 'redux-saga/effects'

import StartupActions from '~/redux/startup'


export default startup = () ->
    yield put StartupActions.finishStartup()
    return
