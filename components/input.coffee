import React from "react"

import c from "classnames"

Input = ({
    className
    id
    style
    children
    type
    placeholder
    value
    onChange
    onKeyPress
    props...
}) ->
    <div className={ c("flex-center", className) } id={ id ? "" } style={ style } {props...}>
        { children }
        <input
            type={ type }
            placeholder={ placeholder }
            value={ value }
            onChange={ onChange }
            onKeyPress={ onKeyPress }
        />
        <style jsx>{ """#{} // stylus
            div
                background alpha(white, 20%)
                margin 1rem 0
                padding 1rem 0.8rem
                min-width 300px
                border-radius 4px
                ease-out 'box-shadow'

                input
                    color white
                    border none
                    background transparent
                    width 100%
                    margin 0 0.6rem

                    &::placeholder
                        color alpha(white, 50%)

        """ }</style>
    </div>

export default Input
