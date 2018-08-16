import React from "react"
import { connect } from "react-redux"

import c from "classnames"

import Brand from "~/components/brand"
import NavLinks from "~/components/navlinks"

Navbar = ({
    className
    id
    style
    children
    height = 60
    navbarConfig
    pathname
    props...
}) ->
    <nav
        className={ c("flex-center", "px-4", "py-4", "fill-width-exact", className) }
        id={ id ? "" }
        style={{
            height: height
            background: navbarConfig.background
            display: if navbarConfig.hidden then "none"
            style...
        }}
        {props...}>
        <Brand />
        <div className="flex-grow-1" />
        <NavLinks />
        <style jsx>{ """#{} // stylus
            nav
                absolute top left
                background transparent
        """ }</style>
    </nav>

mapStateToProps = ({ ui }) ->
    navbarConfig: ui.navbar

mapDispatchToProps = (dispatch) -> {}

export default connect(mapStateToProps, mapDispatchToProps)(Navbar)
