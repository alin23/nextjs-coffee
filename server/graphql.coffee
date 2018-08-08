{ ApolloServer, gql } = require 'apollo-server-micro'
{ GRAPHQL_PATH } = require './config'

user =
    id: 'USER'
    name: 'User'
    username: 'user'
    password: 'pass'

typeDefs = gql"#{}
    type Query {
        me: User
    }
    type User {
        id: ID
        name: String
        username: String
        password: String
    }
"

resolvers =
    Query:
        me: (root, args, context) -> user

apolloServer = new ApolloServer({ typeDefs, resolvers })
graphqlHandler = apolloServer.createHandler({ path: GRAPHQL_PATH })

module.exports = {
    graphqlHandler
}
