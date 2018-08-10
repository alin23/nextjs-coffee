import { createActions, createReducer } from 'reduxsauce'

import Immutable from 'seamless-immutable'

{ Types, Creators } = createActions(
    authenticate: ['username', 'password']
    finishAuthentication: ['ok', 'user']
    setUser: ['user']
, { prefix: 'auth/' })

export INITIAL_STATE = Immutable(
    authenticating: false
    authenticated: false
    user: null
)

export { Types as AuthTypes }
export default Creators

authenticate = (state) -> {
    state...
    authenticating: true
}

setUser = (state, { user }) -> {
    state...
    user
}

finishAuthentication = (state, { ok, user }) -> {
    state...
    user
    authenticating: false
    authenticated: ok
}

ACTION_HANDLERS =
  "#{ Types.AUTHENTICATE }": authenticate
  "#{ Types.FINISH_AUTHENTICATION }": finishAuthentication
  "#{ Types.SET_USER }": setUser

export reducer = createReducer(INITIAL_STATE, ACTION_HANDLERS)
