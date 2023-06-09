defmodule GeodataApi.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: GeodataApi.Worker.start_link(arg)
      # {GeodataApi.Worker, arg}
      Geodata_api.Repo,
      {Plug.Cowboy, scheme: :http, plug: GeodataApi.Router, options: [port: Application.get_env(:geodata_api, :port)]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: GeodataApi.Supervisor]
    Supervisor.start_link(children, opts)
  end
end


