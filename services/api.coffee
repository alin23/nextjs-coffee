import apisauce from "apisauce"
import axios from "axios"
import getConfig from "next/config"

import cacheAdapterEnhancer from "~/lib/cache"
import Raven from "~/lib/raven"

{ serverRuntimeConfig, publicRuntimeConfig } = getConfig()

class API
    constructor: (ctx, baseURL) ->
        @ctx = ctx
        @baseURL =
            baseURL ? (
                if ctx.isServer
                    publicRuntimeConfig.localApiUrl
                else
                    publicRuntimeConfig.remoteApiUrl
            )

        @adapter =
            if ctx.isServer
                @getCacheAdapter()
            else
                null

        @client = apisauce.create(
            adapter: @adapter
            baseURL: @baseURL
            headers: {}
            timeout: 60000
        )
        if not ctx.isServer
            @client.addMonitor(console.tron.apisauce)

        @client.addResponseTransform((response) ->
            if not response.ok
                responseContext =
                    responseData: response.data
                    responseStatus: response.status
                    responseHeaders: response.headers
                    axiosConfig: response.config
                    responseDuration: response.duration

                eventId = Raven.captureException(response.originalError ? response.problem,
                    extra: responseContext)
                eventId = eventId?._lastEventId ? eventId
                response.sentryEventId = eventId

                request = response.originalError?.request)

    getCacheAdapter: () ->
        cacheAdapterEnhancer(axios.defaults.adapter,
            enabledByDefault: true
            defaultCache: @ctx.cache)

    setHeader: () ->
        @client.setHeader

    authenticate: (username, password) ->
        @client.get("authenticate/#{ username }/#{ password }")

export default API
