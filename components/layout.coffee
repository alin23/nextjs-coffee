import React from 'react'

import colors from '~/styles/colors'

import config from '~/config'

export default Layout = (props) ->
    <div
        className="
            layout-container
            #{ props.className ? '' }"
        style={ props.style }>
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
        { props.children }
    </div>
