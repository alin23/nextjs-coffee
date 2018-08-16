import React from "react"

import c from "classnames"

import Navbar from "~/components/navbar"

import colors from "~/styles/colors"

import config from "~/config"

export default Layout = ({ className, style, children }) ->
    <div className={ c("flex-column-center", "layout-container", className) } style={ style }>
        <style global jsx>{ """#{} // stylus
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
                background-color white !important
        """ }</style>
        <Navbar />
        { children }
    </div>
