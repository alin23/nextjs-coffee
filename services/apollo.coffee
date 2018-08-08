import { HttpLink } from 'apollo-link-http'
import { withData } from 'next-apollo'

config =
    link: new HttpLink(
        uri: 'https://api.graph.cool/simple/v1/cjkl629s83g0q01931q0q3t0c'
        opts:
            credentials: 'same-origin'
  )

export default withData(config)
