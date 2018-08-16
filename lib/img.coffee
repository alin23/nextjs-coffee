import config from "~/config"

getSrcSet = (name, ext) ->
    Object.values(config.WIDTH)
        .map((width) ->
            "#{ config.STATIC }/img/#{ name }/\
        #{ name }_#{ width }.#{ ext } \
        #{ width }w")
        .join(",")
