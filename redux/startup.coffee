import Immutable from "seamless-immutable"

PREFIX = "startup/"
INITIAL_STATE = Immutable(starting: false)

startup = (state, ctx) ->
    {
        state...
        starting: true
    }

finishStartup = (state, ctx) ->
    {
        state...
        starting: false
    }
