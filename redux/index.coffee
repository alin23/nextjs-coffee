import { combineReducers } from 'redux'
import undoable, { includeAction } from 'redux-undo'

import getRootSaga from '~/sagas'

import configureStore from './store'


createStore = (initialState = {}, ctx) ->
    rootReducer = combineReducers(
        startup: require('./startup').reducer
        ui: require('./ui').reducer
    )

    configureStore(rootReducer, getRootSaga, initialState, ctx)

export default createStore
