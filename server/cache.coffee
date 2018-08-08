{ send } = require 'micro'
{ parse } = require 'url'
LRUCache = require 'lru-cache'
{ PRODUCTION } = require './config'

ssrCache = new LRUCache({
    max: 100
    maxAge: 1000 * 60 * 60
})

getCacheKey = (req) ->
    return "#{ req.url }"

renderAndCache = (app, req, res) ->
    key = getCacheKey(req)

    if PRODUCTION and ssrCache.has(key)
        await return ssrCache.get(key)

    { pathname, query } = parse(req.url, true)
    try
        html = await app.renderToHTML(req, res, pathname, query)

        if res.statusCode isnt 200
            await return html

        ssrCache.set(key, html)
        await return html
    catch err
        app.renderError(err, req, res, pathname, query)

module.exports = {
    renderAndCache
}
