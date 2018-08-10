import Document, { Head, Main, NextScript } from 'next/document'

import Links from '~/components/links'
import Meta from '~/components/meta'

import config from '~/config'


export default class MyDocument extends Document
    @getInitialProps: (ctx) ->
        initialProps = await Document.getInitialProps(ctx)
        return { initialProps... }

    googleFonts: (fonts) ->
        fontString = ("#{ name }:#{ weights.join(',') }" for name, weights of fonts).join('|')
        "https://fonts.googleapis.com/css?family=#{ fontString }"

    render: ->
        <html>
            <Head>
                <title>{ config.APP_NAME }</title>
                <Meta
                    name={ config.APP_NAME }
                    description={ config.APP_DESCRIPTION }
                    image="#{ config.STATIC }/img/screenshot.jpg"
                    openGraph={
                        url: "https://www.#{ config.DOMAIN }"
                        type: 'website'
                    }
                    facebook={ { } }
                    appleMobileWebAppStatusBarStyle='black'
                    appleMobileWebAppCapable={ false }
                />
                <Links
                    css={[
                        @googleFonts(config.FONTS)
                    ]}
                />
            </Head>
            <body>
                <Main />
                <NextScript />
            </body>
        </html>
