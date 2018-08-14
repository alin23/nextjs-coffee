import gql from 'graphql-tag'


export me = gql"""#{}
    query me {
        allUsers {
            nodes {
                id
                email
                username
                fullname
            }
        }
    }
"""

export userById = gql"""#{}
    query userById($id: String) {
        userById(id: $id) {
            id
            email
            username
            fullname
        }
    }
"""

export authenticate = gql"""#{}
    mutation auth($email: String!, $password: String!) {
        authenticate(input: { email: $email, password: $password }) {
            jwtToken
        }
    }
"""
