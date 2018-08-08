import { graphql } from 'react-apollo'

import gql from 'graphql-tag'

import config from '~/config'

import { fillWindow, flexColumnCenter } from '~/stylus/app.styl'
import { mb3, mt5 } from '~/stylus/bootstrap.styl'

Index = ({ data }) ->
    <div className="#{ fillWindow } #{ flexColumnCenter } container">
        <h1 className="#{ mb3 } #{ mt5 } app-title">
            { if data.me
                "Hello #{ data.me.name }!"
            else
                config.APP_NAME }
        </h1>
        <h5 className='app-description'>
            { config.APP_DESCRIPTION }
        </h5>
        <style jsx>{"""#{} // stylus
            .container
                background mauveBg

                h1, h5
                    text-align center
                    position relative
                    z-index 1

                h5
                    +mobile()
                        font-size 16px

                .app-title
                    color lunarYellow
                    font-weight bold
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
export default graphql(me)(Index)
