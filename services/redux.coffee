import React, { Component } from 'react'

_Promise = Promise
_debug = false
DEFAULT_KEY = '__NEXT_REDUX_STORE__'
isServer = not window?

export setPromise = (Promise) ->
    _Promise = Promise

###
  @param makeStore
  @param initialState
  @param config
  @param ctx
  @return {{ getState: function, dispatch: function }}
###
initStore = ({ makeStore, initialState, config, ctx = { } }) ->
    { storeKey } = config

    createStore = () -> makeStore(
        config.deserializeState(initialState)
        {
            ctx...
            config...
            isServer
        }
    )

    return createStore() if isServer

    # Memoize store if client
    window[storeKey] ?= createStore()

    return window[storeKey]


###
  @param makeStore
  @param config
  @return { function(App): {getInitialProps, new(): WrappedApp, prototype: WrappedApp }}
###
withRedux = (makeStore, config = {}) ->
    config = {
        storeKey: DEFAULT_KEY
        debug: _debug
        serializeState: (state) -> state
        deserializeState: (state) -> state
        config...
    }

    (App) ->
        class WrappedApp extends Component
            @displayName: "withRedux(#{ App.displayName or App.name or 'App' })"

            @getInitialProps: (appCtx) ->
                throw new Error('No app context') if not appCtx
                throw new Error('No page context') if not appCtx.ctx

                store = initStore({
                    makeStore
                    config
                    ctx: appCtx.ctx
                })

                if config.debug
                    console.log(
                        '1. WrappedApp.getInitialProps wrapper got the store with state',
                        store.getState()
                    )

                appCtx.ctx.store = store
                appCtx.ctx.isServer = isServer

                initialProps = {}

                if App.getInitialProps
                    initialProps = await App.getInitialProps(appCtx) ? {}

                if config.debug
                    console.log(
                        '3. WrappedApp.getInitialProps has store state',
                        store.getState()
                    )

                return {
                    store
                    isServer
                    initialState: config.serializeState(store.getState())
                    initialProps: initialProps
                }

            constructor: (props, context) ->
                super(props, context)
                { initialState, store } = props
                hasStore = store? and store.dispatch? and store.getState?

                #TODO Always recreate the store even if it could be reused?
                # @see https:#github.com/zeit/next.js/pull/4295#pullrequestreview-118516366
                store = if hasStore then store else initStore({
                    makeStore
                    initialState
                    config
                })

                if config.debug
                    console.log(
                        '4. WrappedApp.render',
                        (if hasStore
                            'picked up existing one,'
                        else
                            'created new store with'),
                        'initialState', initialState
                    )

                @store = store

            render: () ->
                { initialProps, initialState, store, props... } = @props

                # Cmp render must return something like <Provider><Component /></Provider>
                <App { props... } { initialProps... } store={ @store } />

export default withRedux
