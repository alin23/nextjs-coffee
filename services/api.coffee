import apisauce from 'apisauce'
import axios from 'axios'
import getConfig from 'next/config'

import cacheAdapterEnhancer from '~/lib/cache'
import Raven from '~/lib/raven'

{ serverRuntimeConfig, publicRuntimeConfig } = getConfig()


create = (ctx, baseURL = publicRuntimeConfig.apiURL) ->
    adapter = if not ctx.isServer
        null
    else
        cacheAdapterEnhancer(
            axios.defaults.adapter,
            {
                enabledByDefault: true
                defaultCache: ctx.cache
            }
        )

    api = apisauce.create({
        baseURL
        headers: {}
        adapter
        timeout: 60000
    })
    if window?
        api.addMonitor(console.tron.apisauce)

    api.addResponseTransform((response) ->
        if not response.ok
            responseContext = {
                responseData: response.data
                responseStatus: response.status
                responseHeaders: response.headers
                axiosConfig: response.config
                responseDuration: response.duration
            }

            eventId = Raven.captureException(
                response.originalError ? response.problem,
                { extra: responseContext }
            )
            eventId = eventId?._lastEventId ? eventId
            response.sentryEventId = eventId

            request = response.originalError?.request
    )


    return {
        setHeader: api.setHeader
    }

export default { create }
