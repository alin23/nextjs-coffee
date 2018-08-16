import cookie from "cookie"
import JSCookie from "js-cookie"
import uuid4 from "uuid/v4"

import config from "~/config"

export getAuthTokenCookie = (req) ->
    getCookie(config.AUTH_TOKEN_COOKIE_KEY, req)

export setAuthTokenCookie = (authToken, res) ->
    if authToken?
        setCookie(
            config.AUTH_TOKEN_COOKIE_KEY
            authToken
            res
            config.AUTH_TOKEN_EXPIRATION_DAYS
        )

export removeAuthTokenCookie = (res) ->
    removeCookie(config.AUTH_TOKEN_COOKIE_KEY, res, config.AUTH_TOKEN_EXPIRATION_DAYS)

export setCookie = (key, value, res, expires = 7) ->
    if res?
        setCookieToServer(key, value, res, expires)
    else
        JSCookie.set(key, value, expires: expires)

export removeCookie = (key, res, expires = 7) ->
    if res?
        setCookieToServer(key, "", res, -1000)
    else
        JSCookie.remove(key, expires: expires)

export getCookie = (key, req) ->
    if req?
        cookie.parse(req.headers?.cookie ? "")[key]
    else
        JSCookie.get(key)

setCookieToServer = (key, value, res, expires) ->
    expireDate = new Date()
    expireDate.setMilliseconds(expireDate.getMilliseconds() + expires * 864e5)
    res?.setHeader("Set-Cookie", cookie.serialize(key, value, expires: expireDate))
