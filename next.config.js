const nib = require('nib')
const rupture = require('rupture')
const withBundleAnalyzer = require('@zeit/next-bundle-analyzer')
const withCoffeescript = require('next-coffeescript')
const withSourceMaps = require('@zeit/next-source-maps')
const LodashModuleReplacementPlugin = require('lodash-webpack-plugin')
const webpack = require('webpack')
const { PHASE_DEVELOPMENT_SERVER } = require('next/constants')

const {
    API_PATH,
    APP_DESCRIPTION,
    APP_NAME,
    AUTH_TOKEN_COOKIE_KEY,
    AUTH_TOKEN_EXPIRATION_DAYS,
    BUNDLE_ANALYZE,
    DOMAIN,
    GIT_SHA,
    GRAPHQL_PATH,
    NODE_ENV,
    SENTRY_DSN,
    STATIC_PATH,
    WS_PATH,
} = process.env

module.exports = (phase, { defaultConfig }) => {
    const DEV = phase === PHASE_DEVELOPMENT_SERVER

    const localApiUrl = `http://localhost:3000${API_PATH}/`
    const remoteApiUrl = DEV ? localApiUrl : `${API_PATH}/`

    const localGraphQlUrl = `http://localhost:3000${GRAPHQL_PATH}`
    const remoteGraphQlUrl = DEV ? localGraphQlUrl : GRAPHQL_PATH

    const localWsUrl = `ws://localhost:3000${WS_PATH}`
    const remoteWsUrl = DEV ? localWsUrl : `wss://www.${DOMAIN}${WS_PATH}`

    return withSourceMaps(
        withBundleAnalyzer(
            withCoffeescript({
                ...defaultConfig,
                publicRuntimeConfig: {
                    localApiUrl,
                    remoteApiUrl,
                    localGraphQlUrl,
                    remoteGraphQlUrl,
                    localWsUrl,
                    remoteWsUrl,

                    appName: APP_NAME,
                    appDescription: APP_DESCRIPTION,
                    debug: DEV,
                    domain: DOMAIN,
                    gitSHA: GIT_SHA,
                    sentryDSN: SENTRY_DSN,
                    staticPath: STATIC_PATH,
                    authTokenCookieKey: AUTH_TOKEN_COOKIE_KEY,
                    authTokenExpirationDays: parseInt(AUTH_TOKEN_EXPIRATION_DAYS),
                },
                analyzeServer: ['server', 'both'].includes(BUNDLE_ANALYZE),
                analyzeBrowser: ['browser', 'both'].includes(BUNDLE_ANALYZE),
                webpack(config, { dev, isServer }) {
                    console.log('Mode: %s', isServer ? 'Server' : 'Client')
                    console.log('    Environment: %s', NODE_ENV)
                    console.log('    Development: %s', dev)
                    config.module.rules.push({
                        test: /\.(png|jpg|gif|eot|ttf|woff|woff2)$/,
                        use: { loader: 'url-loader', options: { limit: 100000 } },
                    })
                    config.module.rules.push({
                        test: /\.json$/,
                        loader: 'json-loader',
                    })
                    config.module.rules.push({
                        test: /\.svg$/,
                        exclude: /node_modules/,
                        loader: 'svg-react-loader',
                        query: {
                            classIdPrefix: '[name]-[hash:8]__',
                            filters: [],
                            propsMap: {
                                fillRule: 'fill-rule',
                                size: 'width',
                                color: 'stroke',
                            },
                            xmlnsTest: /^xmlns.*$/,
                        },
                    })

                    config.plugins.push(new webpack.IgnorePlugin(/^raven$/))
                    config.plugins.push(new LodashModuleReplacementPlugin({ shorthands: true }))
                    if (!dev) {
                        config.plugins.push(new webpack.IgnorePlugin(/^reactotron.*/))
                    }

                    return config
                },
            })
        )
    )
}
