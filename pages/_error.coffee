import NextError from 'next/error'

import Raven from '~/lib/raven'

class MyError extends NextError
    @getInitialProps: (ctx) ->
        if ctx.err
            console.error(ctx.err)
            Raven.captureException(ctx.err)
        return await NextError.getInitialProps(ctx)



export default MyError
