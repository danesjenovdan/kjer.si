defmodule KjerSi.Repo do
  use Ecto.Repo,
    otp_app: :kjer_si,
    adapter: Ecto.Adapters.Postgres
end
