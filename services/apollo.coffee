import { HttpLink } from 'apollo-link-http'
import { withData } from 'next-apollo'

config =
    link: new HttpLink(
        uri: 'http://localhost:3000/graphql'
        opts:
            credentials: 'same-origin'
  )

export default withData(config)
