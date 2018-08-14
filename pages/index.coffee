import { graphql } from 'react-apollo'

import config from '~/config'

Hero = ({ className, id, style, children, props... }) ->
    <div
        className="
            flex-grow-1
            fill-width-exact
            flex-column-center
            hero #{ className ? '' }"
        id={ id ? '' }
        style={ style }
        { props... }>
        <h1 className="mb-3 mt-5 app-title">
            { config.APP_NAME }
        </h1>
        <h5 className='app-description'>
            { config.APP_DESCRIPTION }
        </h5>
        <style jsx>{"""#{} // stylus
            .hero
                background white
                min-height 500px

                h1, h5
                    text-align center
                    position relative
                    z-index 1
                    font-size 4rem

                h5
                    font-size 2rem
                    +mobile()
                        font-size 1rem

                .app-title
                    color black
                    font-weight bold

                .app-description
                    color blue
        """}</style>
    </div>

LandingPage = ({ className, id, style, children, props... }) ->
    <div
        className={ className ? '' }
        id={ id ? '' }
        style={ style }
        { props... }>
        <Hero />
    </div>

class Index extends React.PureComponent
    render: ->
        <LandingPage className="fill-window flex-column-center container" />

export default Index
