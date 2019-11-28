FROM elixir:latest

RUN apt-get update && \
  apt-get install -y postgresql-client inotify-tools

WORKDIR /app

CMD ["/app/entrypoint.sh"]
