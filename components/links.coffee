import React from "react"

export default Links = ({ css = [] }) ->
    <React.Fragment>
        { css.map((url) ->
            <link key={ url } href={ url } rel="stylesheet" />) }
    </React.Fragment>
