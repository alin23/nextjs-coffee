import React from 'react'

import Navbar from '~/components/navbar'

import colors from '~/styles/colors'

import config from '~/config'

import { flexColumnCenter } from '~/stylus/app.styl'

export default Layout = ({ className, style, children }) ->
    <div
        className="
            #{ flexColumnCenter }
            layout-container
            #{ className ? '' }"
        style={ style }>
        <style global jsx>{"""#{} // stylus
            html
            body
            body > #__next
            body > div[data-reactroot]
            .layout-container
                height 100vh
                width 100vw
                min-height @height
                min-width @width

            html
            body
                background-size cover
                background white
        """}</style>
        <Navbar />
        { children }
    </div>
