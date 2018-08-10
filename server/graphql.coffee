{ ApolloServer, gql } = require 'apollo-server-micro'
cors = require('micro-cors')()

{ GRAPHQL_PATH } = require './config'
{ getAuthTokenCookie } = require './cookie'

users = [
    {
        id: 'USER'
        name: 'User'
        username: 'user'
        password: 'pass'
        token: '4c6899db-fc3d-4158-809c-5d74ba6c4730'
    }
]

typeDefs = gql"#{}
    type Query {
        me: User
        authenticate(username: String, password: String): User
    }
    type User {
        id: ID
        name: String
        username: String
        password: String
        token: String
    }
"

resolvers =
    Query:
        me: (root, args, context) ->
            if context.authToken?
                return users.find((user) -> user.token is context.authToken)
            return null

        authenticate: (root, args, context) -> users.find(
            (user) ->
                user.username is args.username and
                user.password is args.password
        )

apolloServer = new ApolloServer({
    typeDefs
    resolvers
    context: ({ req }) ->
        authToken: getAuthTokenCookie(req)
})
graphqlHandler = cors(apolloServer.createHandler({ path: GRAPHQL_PATH }))

module.exports = {
    graphqlHandler
    users
}
