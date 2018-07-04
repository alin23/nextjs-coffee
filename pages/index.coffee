import config from '~/config'

WIDTHS = [
    8120, 5260, 3840, 2560,
    1920, 1280, 992, 768, 320
]

getSrcSet = (name, ext) ->
    WIDTHS.map((width) ->
        "#{ config.STATIC }/img/#{ name }/\
        #{ name }_#{ width }.#{ ext } \
        #{ width }w"
    ).join(',')


export default (props) ->
    <div className='fill-window flex-column-center container'>
        <h1 className='mb-3 mt-5 app-title'>
            App
        </h1>
        <h5 className='app-description'>
            Description
        </h5>
        <style jsx>{"""#{} // stylus
            .container
                background mauveBg

                h1, h5
                    text-align center
                    position relative
                    z-index 1

                h5
                    @media (max-width: $mobile)
                        font-size 16px

                .app-title
                    color lunarYellow
                    font-weight bold
        """}</style>
    </div>
