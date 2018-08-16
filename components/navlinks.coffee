import React from "react"
import { Query } from "react-apollo"
import { connect } from "react-redux"

import c from "classnames"
import Link from "next/link"

import { removeAuthTokenCookie } from "~/lib/cookie"

import AuthActions from "~/redux/auth"

import { me } from "~/gql"

NavLink = ({ className, id, style, children, href, color, props... }) ->
    <Link prefetch href={ href }>
        <a
            className={ c("mx-3", className) }
            id={ id ? "" }
            style={{
                color: color
                fontSize: 20
                style...
            }}
            {props...}>
            { children }
            <style jsx>{ """#{} // stylus
                a
                    ease-out color
                    color red
                    font-weight bold
                    &:hover
                        color blue
                        text-decoration none
            """ }</style>
        </a>
    </Link>

NavLinks = ({ className, id, style, children, setAuthToken, authToken, props... }) ->
    <div className={ c("flex-center", className) } id={ id ? "" } style={ style } {props...}>
        <Query query={ me } skip={ not authToken? }>
            { ({ loading, error, data, client }) ->
                if not loading and data?.allUsers?.nodes?[0]? and authToken?
                    user = data?.allUsers.nodes[0]
                    [
                        <NavLink
                            onClick={ () ->
                                removeAuthTokenCookie()
                                setAuthToken(null)
                                client.resetStore()
                             }
                            key="logout"
                            href="/">
                            LOGOUT
                        </NavLink>
                        <NavLink key="user" href="/user">
                            { user.fullname }
                            <img
                                className="ml-2 user-image"
                                src="https://source.unsplash.com/64x64/?face"
                                alt="User Image"
                            />
                        </NavLink>
                    ]
                else
                    <NavLink href="/login">LOGIN</NavLink>
             }
        </Query>
        <style jsx>{ """#{} // stylus
            .user-image
                border-radius 100px
                height 26px
                width @height
        """ }</style>
    </div>

mapStateToProps = ({ auth }) ->
    authToken: auth.token

mapDispatchToProps = (dispatch) ->
    setAuthToken: (token) -> dispatch(AuthActions.setToken(token))

export default connect(mapStateToProps, mapDispatchToProps)(NavLinks)
