{ createServer } = require 'http'
{ join } = require 'path'
{ parse } = require 'url'
LRUCache = require 'lru-cache'

next = require 'next'

dev = process.env.NODE_ENV isnt 'production'
production = not dev
staticDir = if dev
    '/static'
else
    'https://static.domain.tld'

port = process.env.NEXT_PORT ? 3000
app = next({ dev })
handle = app.getRequestHandler()
ssrCache = new LRUCache({
    max: 100
    maxAge: 1000 * 60 * 60
})
cacheablePages = [
    '/'
]

handler = (req, res) ->
    parsedUrl = parse(req.url, true)
    rootStaticFiles = [
        '/robots.txt'
        '/favicon.ico'
        '/sitemap.xml'
    ]
    { pathname, query } = parsedUrl

    if pathname in rootStaticFiles
        res.writeHead(303, { Location: "#{ staticDir }#{ pathname }" })
        res.end()
        res.finished = true
    else if pathname in cacheablePages
        renderAndCache(req, res, pathname, query)
    else
        handle(req, res, parsedUrl)

app.prepare().then(() ->
    createServer(handler).listen(port, (err) ->
        throw err if err
        console.log("✨  Custom server ready on http://localhost:#{ port }")
    )
)

getCacheKey = (req) ->
    return "#{ req.url }"

renderAndCache = (req, res, pagePath, queryParams) ->
    key = getCacheKey(req)

    if production and ssrCache.has(key)
        res.setHeader('x-cache', 'HIT')
        res.end(ssrCache.get(key))
        await return

    try
        html = await app.renderToHTML(req, res, pagePath, queryParams)

        if res.statusCode isnt 200
            res.send(html)
            return

        ssrCache.set(key, html)

        res.setHeader('x-cache', 'MISS')
        res.end(html)
    catch err
        app.renderError(err, req, res, pagePath, queryParams)
