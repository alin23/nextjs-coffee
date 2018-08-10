DEV = process.env.NODE_ENV isnt 'production'
PRODUCTION = not DEV

ROOT_STATIC_FILES = [
    'robots.txt'
    'favicon.ico'
    'sitemap.xml'
]
{
    API_PATH
    GRAPHQL_PATH
    STATIC_PATH
    AUTH_TOKEN_COOKIE_KEY
    AUTH_TOKEN_EXPIRATION_DAYS
} = process.env

AUTH_TOKEN_EXPIRATION_DAYS = parseInt(AUTH_TOKEN_EXPIRATION_DAYS)

module.exports = {
    DEV
    PRODUCTION
    ROOT_STATIC_FILES
    STATIC_PATH
    GRAPHQL_PATH
    API_PATH
    AUTH_TOKEN_COOKIE_KEY
    AUTH_TOKEN_EXPIRATION_DAYS
}
