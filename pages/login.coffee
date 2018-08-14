import React from 'react'
import { ApolloConsumer, Mutation } from 'react-apollo'
import { connect } from 'react-redux'

import Router from 'next/router'

import { title } from 'change-case'

import Brand from '~/components/brand'
import Input from '~/components/input'
import RoundedButton from '~/components/roundedButton'

import { setAuthTokenCookie } from '~/lib/cookie'

import AuthActions from '~/redux/auth'

import colors from '~/styles/colors'
import { AtSign, Lock } from '~/styles/icons'

import config from '~/config'

import { authenticate } from '~/gql'


class Login extends React.PureComponent
    constructor: (props) ->
        super props
        @state =
            email: ''
            password: ''
            authError: false
            invalidEmail: false
            invalidPassword: false
            validEmail: false

    loginInput: (type, className, validate, authFn) ->
        titleType = title(type)
        <Input
            type={ if type is 'password' then 'password' else 'text' }
            placeholder={ titleType }
            value={ @state[type] }
            onChange={ (e) =>
                @setState("#{ type }": e.target.value)
                validKey = "valid#{ titleType }"
                invalidKey = "invalid#{ titleType }"
                if validate?
                    valid = validate(e.target.value)
                    @setState(
                        "#{ invalidKey }": not valid
                        "#{ validKey }": valid
                    )
            }
            onKeyPress={ (e) =>
                if e.charCode is 13
                    @authenticate(authFn)
            }
            style={
                boxShadow: if @state["invalid#{ titleType }"]
                    "0 0 30px #{ colors.BLACK.alpha(0.3) }"
                else if @state["valid#{ titleType }"]
                    "0 0 30px #{ colors.YELLOW.alpha(0.3) }"
                else
                    null
            }
            className="#{ type }-input #{ className ? '' }" >
                {switch type
                    when 'email' then <AtSign />
                    when 'password' then <Lock />
                }
        </Input>

    authenticate: (authFn) ->
        validEmail = @state.email?.length and @state.email.match(config.EMAIL_REGEX)
        validPassword = @state.password?.length
        if validEmail and validPassword
            @setState
                authError: null
                invalidEmail: false
                invalidPassword: false
            authFn(
                variables:
                    email: @state.email
                    password: @state.password
            )
        else if not validEmail
            @setState
                authError: 'Invalid email'
                invalidEmail: true
                invalidPassword: false
        else if not validPassword
            @setState
                authError: 'Invalid password'
                invalidEmail: false
                invalidPassword: true


    render: ->
        <div className="flex-grow-1 flex-column-center container">
            <div className="flex-column-center login-container">
                <h1>Login</h1>
                <Mutation
                    mutation={ authenticate }
                    onCompleted={ (data) =>
                        if data?.authenticate?.jwtToken?
                            @props.setAuthToken(data.authenticate.jwtToken)
                    }
                    onError={ (error) => @setState(authError: 'Wrong email or password') }>
                    { (authenticate, {data, loading, error }) =>
                        [
                            @loginInput(
                                'email', 'mt-5',
                                validate = (val) -> val.match(config.EMAIL_REGEX)
                                authenticate
                            )
                            @loginInput(
                                'password', 'mb-5'
                                validate = (val) -> val.length > 0
                                authenticate
                            )
                            <RoundedButton
                                loading={ loading }
                                onClick={ () =>
                                    @authenticate(authenticate)
                                }
                                color={ colors.BLACK }>
                                Submit
                            </RoundedButton>
                            <p className='mt-3 text-center error' style={
                                opacity: if @state.authError?.length then 1 else 0
                            }>
                                { @state.authError }
                            </p>
                        ]
                    }
                </Mutation>
            </div>
            <style jsx>{"""#{} // stylus
                .login-container
                    soft-shadow blue 0.7 1 3
                    border-radius 30px
                    background blue
                    width 500px
                    height @width * 1.2
                    +mobile()
                        border-radius 0
                        box-shadow none
                        width 100vw
                        height 100vh

                    .error
                        color white
                        ease-out 0.4 opacity
                        margin-top 0.5rem
            """}</style>
        </div>

mapStateToProps = ({ auth }) ->
    authenticating: auth.authenticating
    authenticated: auth.authenticated
    user: auth.user

mapDispatchToProps = (dispatch) ->
    setAuthToken: (token) -> dispatch(AuthActions.setToken(token))

export default connect(mapStateToProps, mapDispatchToProps)(Login)
