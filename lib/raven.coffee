import Raven from 'raven-js'

import config from '~/config'


# https://gist.github.com/impressiver/5092952
clientIgnores =
    ignoreErrors: [
        'top.GLOBALS'
        'originalCreateNotification'
        'canvas.contentDocument'
        'MyApp_RemoveAllHighlights'
        'http://tt.epicplay.com'
        "Can't find variable: ZiteReader"
        'jigsaw is not defined'
        'ComboSearch is not defined'
        'http://loading.retry.widdit.com/'
        'atomicFindClose'
        'fb_xd_fragment'
        'bmi_SafeAddOnload'
        'EBCallBackMessageReceived'
        'conduitPage'
        'Script error.'
    ]
    ignoreUrls: [
        # Facebook flakiness
        /graph\.facebook\.com/i
        # Facebook blocked
        /connect\.facebook\.net\/en_US\/(all|sdk)\.js/i
        # Woopra flakiness
        /eatdifferent\.com\.woopra-ns\.com/i
        # Chrome extensions
        /extensions\//i
        /^chrome:\/\//i
        # Other plugins
        /127\.0\.0\.1:4001\/isrunning/i # Cacaoweb
        /webappstoolbarba\.texthelp\.com\//i
        /metrics\.itunes\.apple\.com\.edgesuite\.net\//i
    ]

options =
    autoBreadcrumbs: true
    captureUnhandledRejections: true
    release: config.VERSION
    environment: if config.DEV
        'development'
    else
        'production'

IsomorphicRaven = if process.browser is true
    Raven.config(config.SENTRY_DSN, {
        clientIgnores...
        options...
    }).install()
    Raven
else
    # https://arunoda.me/blog/ssr-and-server-only-modules
    NodeRaven = eval("require('raven')")
    NodeRaven.config(config.SENTRY_DSN, options).install()
    NodeRaven

export default IsomorphicRaven
