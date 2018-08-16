import React from "react"

import c from "classnames"
import Link from "next/link"

Brand = ({ className, id, style, children, size = 2, props... }) ->
    <Link prefetch href="/">
        <a
            className={ c("font-heading", className) }
            id={ id ? "" }
            style={{
                fontSize: "#{ size ? 2 }rem"
                style...
            }}
            {props...}>
            <span id="logo-left">Next.js</span>
            <span id="logo-right">App</span>
            <style jsx>{ """#{} // stylus
                a
                    font-weight bold
                    #logo-left
                        ease-out color
                        color black
                    #logo-right
                        ease-out color
                        color blue
                    &:hover
                        text-decoration none
                        #logo-left
                            color blue
                        #logo-right
                            color black

            """ }</style>
        </a>
    </Link>

export default Brand
