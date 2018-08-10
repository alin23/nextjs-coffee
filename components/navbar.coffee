import { connect } from 'react-redux'

import Brand from '~/components/brand'
import NavLinks from '~/components/navlinks'

import { fillWidthExact, flexCenter } from '~/stylus/app.styl'
import { flexGrow1, ml2, mx3, px4, py4 } from '~/stylus/bootstrap.styl'


Navbar = ({
    className, id, style, children, height = 60,
    navbarConfig, pathname, props...
}) ->
    <nav
        className="
            #{ flexCenter }
            #{ px4 } #{ py4 }
            #{ fillWidthExact }
            #{ className ? '' }"
        id={ id ? '' }
        style={{
            height: height
            background: navbarConfig.background
            display: if navbarConfig.hidden then 'none'
            style...
        }}
        { props... }>
        <Brand />
        <div className={ flexGrow1 } />
        <NavLinks />
        <style jsx>{"""#{} // stylus
            nav
                absolute top left
                background transparent
        """}</style>
    </nav>

mapStateToProps = ({ ui }) ->
    navbarConfig: ui.navbar

mapDispatchToProps = (dispatch) -> {}

export default connect(mapStateToProps, mapDispatchToProps)(Navbar)
