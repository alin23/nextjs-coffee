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

### Handlers ###
app = next({ dev: config.DEV })
nextHandler = app.getRequestHandler()

redirectToStaticFile = (req, res) ->
    res.writeHead(303, { Location: "#{ config.STATIC_PATH }/#{ req.params.staticFile }" })
    res.end()
    return null

renderWithCache = (req, res) ->
    renderAndCache(app, req, res)
    return null

startServer = (router) ->
    await app.prepare()
    return router

process.on('SIGUSR2', () ->
    console.log 'Got RESTART signal'
)


### API ###
api = withNamespace(config.API_PATH)

authenticate = (req, res) ->
    { username, password } = req.params
    if username is users[0].username and password is users[0].password
        return users[0]
    else
        send(res, 401, 'Invalid username or password')
        return null

module.exports.startServer = startServer(
    router(
        get(rootStaticFileUrl, redirectToStaticFile)
        get('/', renderWithCache)
        get('/login', renderWithCache)

        api(get('/authenticate/:username/:password', authenticate))

        options(config.GRAPHQL_PATH, graphqlHandler)
        post(config.GRAPHQL_PATH, graphqlHandler)
        get(config.GRAPHQL_PATH, graphqlHandler)

        get('*', nextHandler)
    )
)
