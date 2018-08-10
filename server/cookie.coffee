cookie = require 'cookie'
uuid4 = require 'uuid/v4'

{ AUTH_TOKEN_COOKIE_KEY, AUTH_TOKEN_EXPIRATION_DAYS } = require './config'

getAuthTokenCookie = (req) ->
    getCookie(AUTH_TOKEN_COOKIE_KEY, req)

setAuthTokenCookie = (authToken, res) ->
    if authToken?
        setCookie(
            AUTH_TOKEN_COOKIE_KEY, authToken, res, AUTH_TOKEN_EXPIRATION_DAYS
        )

removeAuthTokenCookie = (res) ->
    setAuthTokenCookie(uuid4(), res)

getCookie = (key, req) ->
    cookie.parse(req.headers?.cookie ? '')[key]

setCookie = (key, value, res, expires = 7) ->
    expireDate = new Date()
    expireDate.setMilliseconds(expireDate.getMilliseconds() + expires * 864e+5)
    res?.setHeader('Set-Cookie', cookie.serialize(key, value, { expires: expireDate }))

removeCookie = (key, res, expires = 7) ->
    setCookie(key, '', res, -1000)

module.exports = {
    getAuthTokenCookie
    setAuthTokenCookie
    removeAuthTokenCookie
    setCookie
    removeCookie
    getCookie
}
