DEV = process.env.NODE_ENV isnt 'production'
PRODUCTION = not DEV

STATIC_DIR = if DEV
    '/static'
else
    'https://static.domain.tld'

ROOT_STATIC_FILES = [
    'robots.txt'
    'favicon.ico'
    'sitemap.xml'
]
GRAPHQL_PATH = '/graphql'

module.exports = {
    DEV
    PRODUCTION
    STATIC_DIR
    ROOT_STATIC_FILES
    GRAPHQL_PATH
}
