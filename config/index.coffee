import getConfig from 'next/config'

import colors from '~/styles/colors'
{ serverRuntimeConfig, publicRuntimeConfig } = getConfig()

DEV = publicRuntimeConfig.debug

export default config =
    STATIC: "#{ publicRuntimeConfig.staticDir }"
    DEV: DEV
    PRODUCTION: not DEV
    FONTS:
        Mukta: [400, 600]
