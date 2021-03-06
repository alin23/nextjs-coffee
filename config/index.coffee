import getConfig from "next/config"

import colors from "~/styles/colors"
{ serverRuntimeConfig, publicRuntimeConfig } = getConfig()

config =
    DOMAIN: publicRuntimeConfig.domain
    APP_NAME: publicRuntimeConfig.appName
    APP_DESCRIPTION: publicRuntimeConfig.appDescription
    STATIC: "#{ publicRuntimeConfig.staticPath }"
    DEV: publicRuntimeConfig.debug
    PRODUCTION: not publicRuntimeConfig.debug
    DISABLE_REACTOTRON: false
    REDUX_DEBUG: false
    FONTS: Mukta: [400, 600]
    VERSION: publicRuntimeConfig.gitSHA ? "dev"
    SENTRY_DSN: publicRuntimeConfig.sentryDSN

    AUTH_TOKEN_COOKIE_KEY: publicRuntimeConfig.authTokenCookieKey
    AUTH_TOKEN_EXPIRATION_DAYS: publicRuntimeConfig.authTokenExpirationDays

    DEFAULT_PAGE_PROPS:
        background: colors.WHITE.s()
        title: publicRuntimeConfig.appName
        description: publicRuntimeConfig.appDescription
        themeColor: colors.YELLOW.s()
        navbar:
            background: colors.TRANSPARENT.s()
            color: colors.BLACK.s()
            hidden: false
    PAGE_PROPS:
        "/": {}
        "/login": navbar: hidden: true
    WIDTH:
        eightKay: 8120
        fiveKay: 5260
        fourKay: 3840
        twoKay: 2560
        oneKay: 1920
        large: 1200
        tablet: 992
        medium: 768
        mobile: 576
        mobileSmall: 320
        thumb: 64
    POLLING: windowResize: 500
    # coffeelint: disable=max_line_length
    EMAIL_REGEX:
        /^(([^<>()\[\]\\.,;:\s@']+(\.[^<>()\[\]\\.,;:\s@']+)*)|('.+'))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/
# coffeelint: enable=max_line_length

export default config
