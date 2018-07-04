import React from "react"

import Head from 'next/head'

import App, { Container } from "next/app"

import Layout from '~/components/layout'

import colors from '~/styles/colors'

import config from '~/config'


AsyncMode = React.unstable_AsyncMode

export default class MyApp extends App
    render: ->
        { Component, props... } = @props

        <AsyncMode>
            <Container>
                <Layout>
                    <Head>
                        <title>App Name</title>
                        <meta
                            name="description"
                            content='App Description' />
                        <meta
                            name="theme-color"
                            content={ colors.MAUVE } />
                        <meta
                            name="msapplication-TileColor"
                            content={ colors.MAUVE } />
                    </Head>
                    <Component { props... } />
                </Layout>
            </Container>
        </AsyncMode>
