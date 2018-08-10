import gql from 'graphql-tag'


export me = gql"#{}
    query me {
        me {
            id
            name
            username
        }
    }
"
