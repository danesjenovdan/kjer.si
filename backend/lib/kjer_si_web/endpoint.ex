defmodule KjerSiWeb.Endpoint do
  use Phoenix.Endpoint, otp_app: :kjer_si

  # Uncomment this and add a comma above to return JSON errors
  # render_errors: [view: KjerSiWeb.ErrorView, accepts: ~w(json), layout: false]

  plug Plug.Static,
    at: "/",
    from: :kjer_si,
    gzip: false,
    only: ~w(admin css fonts images js favicon.ico robots.txt)

  socket "/socket", KjerSiWeb.UserSocket,
    websocket: true,
    longpoll: false

  # Code reloading can be explicitly enabled under the
  # :code_reloader configuration of your endpoint.
  if code_reloading? do
    plug Phoenix.CodeReloader
  end

  plug Plug.RequestId
  plug Plug.Telemetry, event_prefix: [:phoenix, :endpoint]

  plug Plug.Parsers,
    parsers: [:urlencoded, :multipart, :json],
    pass: ["*/*"],
    json_decoder: Phoenix.json_library()

  plug Plug.MethodOverride
  plug Plug.Head
  plug KjerSiWeb.Router
end
