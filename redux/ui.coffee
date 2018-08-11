import Immutable from 'seamless-immutable'

import colors from '~/styles/colors'

import config from '~/config'

PREFIX = 'ui/'
INITIAL_STATE = Immutable(
    windowWidth: config.WIDTH.oneKay
    mobile: false
    mediumScreen: false
    background: null
    title: null
    description: null
    themeColor: null
    pathname: null
    navbar: {}
)

setState = (state, { newState }) -> {
    state...
    newState...
}
