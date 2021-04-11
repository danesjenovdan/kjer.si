FROM elixir:latest

RUN mix local.hex --force \

  && apt-get update \
  && curl -sL https://deb.nodesource.com/setup_14.x | bash \
  && apt-get install -y apt-utils \
  && apt-get install -y nodejs \
  && apt-get install -y build-essential \
  && apt-get install -y inotify-tools \
  && mix local.rebar --force

# this was removed after apt-get update
#   && mix archive.install --force hex phx_new 1.5.8 \
# TODO install nodejs with nvm instead of apt

ENV APP_HOME /app
ENV MIX_ENV k8s

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

COPY mix.exs mix.lock $APP_HOME/

RUN mix deps.get

COPY . /app

RUN mix compile

EXPOSE 4000

CMD ["mix", "phx.server"]
