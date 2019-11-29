#!/usr/bin/env bash

###############################################################
#                                                             #
# NOT BEST PRACTICE I GUESS                                   #
# Getting dependencies after the volume was bound by          #
# docker-compose, because it overrides any actions performed  #
# by the Dockerfile build.                                    #
#                                                             #
# So if you want to have your deps available in entrypoint.sh #
# you need to install them here as well.                      #
#                                                             #
###############################################################

mix local.hex --force
mix local.rebar --force

mix deps.get

mix ecto.setup

exec mix phx.server
