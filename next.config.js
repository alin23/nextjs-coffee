const withBundleAnalyzer = require('@zeit/next-bundle-analyzer')
const withCoffeescript = require('next-coffeescript')
const withSourceMaps = require('@zeit/next-source-maps')
const withProgressBar = require('next-progressbar')
const LodashModuleReplacementPlugin = require('lodash-webpack-plugin')
const webpack = require('webpack')
const { PHASE_DEVELOPMENT_SERVER } = require('next/constants')

module.exports = (phase, { defaultConfig }) => {
    return withProgressBar(
        withSourceMaps(
            withBundleAnalyzer(
                withCoffeescript({
                    ...defaultConfig,
                    publicRuntimeConfig: {
                        debug: phase === PHASE_DEVELOPMENT_SERVER,
                        gitSHA: process.env.GIT_SHA,
                        staticDir:
                            phase === PHASE_DEVELOPMENT_SERVER ? '/static' : 'https://static.domain.tld',
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
}
