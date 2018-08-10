import { Query } from 'react-apollo'

import Link from 'next/link'

import { removeAuthTokenCookie } from '~/lib/cookie'

import { me } from '~/gql'
import { flexCenter } from '~/stylus/app.styl'
import { ml2, mx3 } from '~/stylus/bootstrap.styl'

NavLink = ({ className, id, style, children, href, color, props... }) ->
    <Link prefetch href={ href }>
        <a
            className="#{ mx3 } #{ className ? '' }"
            id={ id ? '' }
            style={{
                color: color
                fontSize: 20
                style...
            }}
            { props... }>
            { children }
            <style jsx>{"""#{} // stylus
                a
                    ease-out color
                    color red
                    font-weight bold
                    &:hover
                        color blue
                        text-decoration none
            """}</style>
        </a>
    </Link>


NavLinks = ({ className, id, style, children, props... }) ->
    <div
        className="#{ flexCenter } #{ className ? '' }"
        id={ id ? '' }
        style={ style }
        { props... }>
        <Query query={ me }>
            { ({loading, error, data, client }) ->
                if not loading and data?.me?.name
                    [
                        <NavLink
                            onClick={ () ->
                                removeAuthTokenCookie()
                                client.resetStore()
                            }
                            key='logout'
                            href='/'>LOGOUT</NavLink>
                        <NavLink
                            key='user'
                            href='/user'>
                            { data.me.name }
                            <img
                                className="#{ ml2 } user-image"
                                src='https://source.unsplash.com/64x64/?face'
                                alt='User Image' />
                        </NavLink>
                    ]
                else
                    <NavLink href='/login'>LOGIN</NavLink>
            }
        </Query>
        <style jsx>{"""#{} // stylus
            .user-image
                border-radius 100px
                height 26px
                width @height
        """}</style>
    </div>


export default NavLinks
