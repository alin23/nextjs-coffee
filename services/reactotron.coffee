import apisaucePlugin from 'reactotron-apisauce'
import Reactotron, { trackGlobalErrors } from 'reactotron-react-js'
import { reactotronRedux } from 'reactotron-redux'
import sagaPlugin from 'reactotron-redux-saga'

import Immutable from 'seamless-immutable'

import { Types as StartupTypes } from '~/redux/startup'

import config from '~/config'


if config.DEV and not config.DISABLE_REACTOTRON
    Reactotron
        .configure(name: config.APP_NAME)
        .use(trackGlobalErrors(
            veto: (frame) -> 'node_modules/next' not in frame.fileName
        ))
        .use(apisaucePlugin())
        .use(reactotronRedux({
            isActionImportant: (action) -> action.type is StartupTypes.STARTUP
            onRestore: (state) -> Immutable(state)
        }))
        .use(sagaPlugin())
        .connect()

    Reactotron.clear()
    window.addEventListener('beforeunload', () ->
        console.tron?.close()
    )
    console.tron = Reactotron
    log = console.log
    console.log = () ->
        log(arguments...)
        console.tron.log(arguments...)

else
    console.tron =
        log: () -> false
        debug: () -> false
        warn: () -> false
        error: () -> false
        display: () -> false
        image: () -> false
