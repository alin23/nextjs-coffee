import { createActions, createReducer } from 'reduxsauce'

import Immutable from 'seamless-immutable'

import colors from '~/styles/colors'

import config from '~/config'


{ Types, Creators } = createActions(
    setState: ['newState']
, { prefix: 'ui/' })

export { Types as UITypes }
export default Creators

export INITIAL_STATE = Immutable(
    windowWidth: config.WIDTH.oneKay
    mobile: false
    mediumScreen: false
    background: null
    title: null
    description: null
    themeColor: null
    navbar: {}
)

setState = (state, { newState }) -> {
    state...
    newState...
}

ACTION_HANDLERS =
    "#{ Types.SET_STATE }": setState

export reducer = createReducer(INITIAL_STATE, ACTION_HANDLERS)
