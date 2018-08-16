import Immutable from "seamless-immutable"

PREFIX = "auth/"
INITIAL_STATE = Immutable(
    user: null
    token: null
)

resetApolloStore = (state, ctx) -> state

setUser = (state, { user }) ->
    {
        state...
        user
    }

setToken = (state, { token }) ->
    {
        state...
        token
    }
