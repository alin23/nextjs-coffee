config = require './config'
{ getAuthTokenCookie } = require './cookie'

users = [
    {
        id: 'USER'
        email: 'user@domain.tld'
        fullname: 'User'
        username: 'user'
        password: 'pass'
    }
]


if not config.DB_URL
    { ApolloServer, gql } = require 'apollo-server-micro'

    resolvers =
        Query:
            me: (root, args, context) ->
                if context.authToken?
                    return users.find((user) -> user.token is context.authToken)
                return null

    typeDefs = gql"#{}
        type Query {
            me: User
        }
        type User {
            id: ID
            email: String
            token: String
            fullname: String
            username: String
            password: String
        }
    "

    apolloServer = new ApolloServer({
        typeDefs
        resolvers
        context: ({ req }) ->
            authToken: getAuthTokenCookie(req)
    })
    graphqlHandler = apolloServer.createHandler({ path: config.GRAPHQL_PATH })
else
    postgraphile = require('postgraphile').default
    graphqlHandler = postgraphile(config.DB_URL, 'public', {
        graphqlRoute: config.GRAPHQL_PATH
        graphiqlRoute: config.GRAPHIQL_PATH
        graphiql: config.DEV
        # coffeelint: disable=max_line_length
        jwtSecret: 'cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e'
        # coffeelint: enable=max_line_length
        jwtPgTypeIdentifier: 'private.jwt_token'
        pgDefaultRole: 'nouser'
    })

module.exports = {
    graphqlHandler
    users
}
