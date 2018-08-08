const nib = require('nib')
const rupture = require('rupture')
const withStylus = require('@zeit/next-stylus')
const withBundleAnalyzer = require('@zeit/next-bundle-analyzer')
const withCoffeescript = require('next-coffeescript')
const withSourceMaps = require('@zeit/next-source-maps')
const withProgressBar = require('next-progressbar')
const LodashModuleReplacementPlugin = require('lodash-webpack-plugin')
const webpack = require('webpack')
const { PHASE_DEVELOPMENT_SERVER } = require('next/constants')

const TEST_MODE = process.env.TEST_MODE === 'true'
const DOMAIN = 'domain.tld'

module.exports = (phase, { defaultConfig }) => {
    const apiDomain =
        phase === PHASE_DEVELOPMENT_SERVER ? 'localhost:3000' : TEST_MODE ? `api-test.${DOMAIN}` : `api.${DOMAIN}`
    const domain = phase === PHASE_DEVELOPMENT_SERVER ? 'localhost' : `www.${DOMAIN}`

    return withStylus(
        withProgressBar(
            withSourceMaps(
                withBundleAnalyzer(
                    withCoffeescript({
                        ...defaultConfig,
                        cssLoaderOptions: {
                            camelCase: true,
                            sourceMap: true,
                        },
                        stylusLoaderOptions: {
                            use: [nib(), rupture()],
                        },
                        publicRuntimeConfig: {
                            appName: 'App',
                            appDescription: 'App Description',
                            debug: phase === PHASE_DEVELOPMENT_SERVER,
                            domain: domain,
                            gitSHA: process.env.GIT_SHA,
                            sentryDSN: process.env.SENTRY_DSN,
                            apiURL:
                                phase === PHASE_DEVELOPMENT_SERVER ? `http://${apiDomain}/` : `https://${apiDomain}/`,
                            wsURL: phase === PHASE_DEVELOPMENT_SERVER ? `ws://${apiDomain}` : `wss://${apiDomain}`,
                            staticDir: phase === PHASE_DEVELOPMENT_SERVER ? '/static' : `https://static.${DOMAIN}`,
                        },
                        cssModules: true,
                        analyzeServer: ['server', 'both'].includes(process.env.BUNDLE_ANALYZE),
                        analyzeBrowser: ['browser', 'both'].includes(process.env.BUNDLE_ANALYZE),
                        webpack(config, { dev, isServer }) {
                            console.log('Mode: %s', isServer ? 'Server' : 'Client')
                            console.log('    Environment: %s', process.env.NODE_ENV)
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
        )
    )
}
