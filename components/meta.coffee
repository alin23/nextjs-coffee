export default Meta = (props) ->
    [
        <meta key="charset" charSet="utf-8" />
        <meta
            key="viewport"
            name="viewport"
            content='
                width=device-width,
                initial-scale=1.0,
                maximum-scale=1.0,
                user-scalable=0,
                shrink-to-fit=no'
        />
        <meta key="image" name="image" content={ props.image } />
        <meta key="name" itemProp="name" content={ props.name } />
        <meta key="description" itemProp="description" content={ props.description } />
        <meta key="item-image" itemProp="image" content={ props.image } />
        <meta
            key="og:title"
            property="og:title"
            content={ props.openGraph.title ? props.name }
        />
        <meta
            key="og:description"
            property="og:description"
            content={ props.openGraph.description ? props.description }
        />
        <meta
            key="og:image"
            property="og:image"
            content={ props.openGraph.image ? props.image }
        />
        <meta key="og:url" property="og:url" content={ props.openGraph.url } />
        <meta
            key="og:site_name"
            property="og:site_name"
            content={ props.openGraph.siteName ? props.name }
        />
        <meta key="og:type" property="og:type" content={ props.openGraph.type } />
        <meta
            key="apple-mobile-web-app-status-bar-style"
            name="apple-mobile-web-app-status-bar-style"
            content={ props.appleMobileWebAppStatusBarStyle }
        />
        <meta
            key="mobile-web-app-capable"
            name="mobile-web-app-capable"
            content={
                if props.appleMobileWebAppCapable
                    "yes"
                else
                    "no"
             }
        />
    ]
