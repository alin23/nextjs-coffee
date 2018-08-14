DEV = process.env.NODE_ENV isnt 'production'

if DEV
    require('dotenv').config(path: '.env.dev')
else
    require('dotenv').config(path: '.env.production')

{ createServer } = require 'http'
{ withNamespace, router, get, post, options } = require('microrouter')
{ send } = require 'micro'

UrlPattern = require('url-pattern')
next = require 'next'

config = require './config'
{ renderAndCache } = require './cache'
{ graphqlHandler, users } = require './graphql'

rootStaticFileUrl = new UrlPattern(
    new RegExp("^/(#{ config.ROOT_STATIC_FILES.join('|') })")
    ['staticFile']
)
postgraphileStaticFileUrl = new UrlPattern(
    new RegExp("^/_postgraphile/graphiql/static/(.+)")
    ['staticFile']
)

### Handlers ###
app = next({ dev: config.DEV })
nextHandler = app.getRequestHandler()

redirectToStaticFile = (req, res) ->
    res.writeHead(303, { Location: "#{ config.STATIC_PATH }/#{ req.params.staticFile }" })
    res.end()
    return

renderWithCache = (req, res) ->
    renderAndCache(app, req, res)
    return

startServer = (router) ->
    await app.prepare()
    return router

process.on('SIGUSR2', () ->
    console.log 'Got RESTART signal'
)


### API ###
api = withNamespace(config.API_PATH)

module.exports.startServer = startServer(
    router(
        get(rootStaticFileUrl, redirectToStaticFile)
        get(postgraphileStaticFileUrl, redirectToStaticFile)
        get('/', renderWithCache)
        get('/login', renderWithCache)

        post(config.GRAPHQL_PATH, graphqlHandler)
        get(config.GRAPHIQL_PATH, graphqlHandler)

        get('*', nextHandler)
    )
)
