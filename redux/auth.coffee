import Immutable from 'seamless-immutable'

PREFIX = 'auth/'
INITIAL_STATE = Immutable(
    authenticating: false
    authenticated: false
    user: null
)

authenticate = (state, { username, password }) -> {
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
