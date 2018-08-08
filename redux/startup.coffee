import { createActions, createReducer } from 'reduxsauce'

import Immutable from 'seamless-immutable'

{ Types, Creators } = createActions(
    startup: null
    finishStartup: null
, { prefix: 'startup/' })

export INITIAL_STATE = Immutable(
    starting: false
)

export { Types as StartupTypes }
export default Creators

startup = (state) -> {
    state...
    starting: true
}

finishStartup = (state) -> {
    state...
    starting: false
}

ACTION_HANDLERS =
  "#{ Types.STARTUP }": startup
  "#{ Types.FINISH_STARTUP }": finishStartup

export reducer = createReducer(INITIAL_STATE, ACTION_HANDLERS)
