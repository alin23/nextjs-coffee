import React from 'react'
import { ApolloConsumer } from 'react-apollo'
import { graphql } from 'react-apollo'
import { connect } from 'react-redux'

import gql from 'graphql-tag'
import Router from 'next/router'

import Brand from '~/components/brand'
import RoundedButton from '~/components/roundedButton'

import AuthActions from '~/redux/auth'

import colors from '~/styles/colors'

import config from '~/config'

import { flexColumnCenter } from '~/stylus/app.styl'
import { flexGrow1, mb5, mt5 } from '~/stylus/bootstrap.styl'

class Login extends React.PureComponent
    constructor: (props) ->
        super props
        @state =
            username: ''
            password: ''
            authError: false

    componentDidUpdate: (prevProps, prevState, snapshot) ->
        if (prevProps.authenticating and not @props.authenticating)
            if @props.authenticated
                Router.push('/')
            else
                @setState
                    authError: true

    render: ->
        <div className="#{ flexGrow1 } #{ flexColumnCenter } container">
            <div className="#{ flexColumnCenter } login-container">
                <h1>Login</h1>
                <input
                    type="text"
                    value={ @state.username }
                    onChange={ (e) => @setState(username: e.target.value) }
                    onKeyPress={ (e) =>
                        if e.charCode is 13 and
                        @state.username?.length and @state.password?.length
                            @props.authenticate(@state.username, @state.password)
                    }
                    className="#{ mt5 } username-input" />
                <input
                    type="password"
                    value={ @state.password }
                    onChange={ (e) => @setState(password: e.target.value) }
                    onKeyPress={ (e) =>
                        if e.charCode is 13 and
                        @state.username?.length and @state.password?.length
                            @props.authenticate(@state.username, @state.password)
                    }
                    className="#{ mb5 } password-input" />
                <RoundedButton
                    loading={ @props.authenticating }
                    onClick={ () =>
                        @props.authenticate(@state.username, @state.password)
                    }
                    color={ colors.BLACK }>
                    Submit
                </RoundedButton>
                <p className='error' style={
                    opacity: if @state.authError then 1 else 0
                }>Try again</p>
            </div>
            <style jsx>{"""#{} // stylus
                .login-container
                    soft-shadow blue 0.4 2 2
                    border-radius 12px
                    background blue
                    width 500px
                    height @width * 1.2
                    +mobile()
                        border-radius 0
                        box-shadow none
                        width 100vw
                        height 100vh

                    input
                        padding 1rem 0.8rem
                        color white
                        min-width 300px
                        border-radius 4px
                        background alpha(white, 20%)
                        border none
                        margin 1rem 0

                    .error
                        color white
                        ease-out 0.4 opacity
                        margin-top 0.5rem
            """}</style>
        </div>

me = gql"#{}
    query me {
        me {
            id
            name
            username
        }
    }
"

mapStateToProps = ({ auth }) ->
    authenticating: auth.authenticating
    authenticated: auth.authenticated
    user: auth.user

mapDispatchToProps = (dispatch) ->
    authenticate: (username, password) ->
        dispatch(AuthActions.authenticate(username, password))

export default graphql(me)(connect(mapStateToProps, mapDispatchToProps)(Login))
