defmodule Geodata_api.Repo do
  use Ecto.Repo,
    otp_app: :geodata_api,
    adapter: Ecto.Adapters.Postgres
end
