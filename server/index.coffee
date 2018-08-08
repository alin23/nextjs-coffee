{ createServer } = require 'http'
{ join } = require 'path'
{ router, get, post, options } = require('microrouter')
{ send } = require 'micro'
UrlPattern = require('url-pattern')
next = require 'next'

config = require './config'
{ renderAndCache } = require './cache'
{ graphqlHandler } = require './graphql'

rootStaticFileUrl = new UrlPattern(
    new RegExp("/(#{ config.ROOT_STATIC_FILES.join('|') })")
    ['staticFile']
)

### Handlers ###
app = next({ dev: config.DEV })
nextHandler = app.getRequestHandler()

redirectToStaticFile = (req, res) ->
    res.writeHead(303, { Location: "#{ config.STATIC_DIR }#{ req.params.staticFile }" })
    res.end()

renderWithCache = (req, res) ->
    renderAndCache(app, req, res)

startServer = (router) ->
    await app.prepare()
    return router

process.on('SIGUSR2', () ->
    console.log 'Got RESTART signal'
)

module.exports.startServer = startServer(
    router(
        get(rootStaticFileUrl, redirectToStaticFile)
        get('/', renderWithCache)
        get('/login', renderWithCache)

        options(config.GRAPHQL_PATH, graphqlHandler)
        post(config.GRAPHQL_PATH, graphqlHandler)
        get(config.GRAPHQL_PATH, graphqlHandler)

        get('*', nextHandler)
    )
)
