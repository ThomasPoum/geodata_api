import Config

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"

config :geodata_api, ecto_repos: [Geodata_api.Repo]

config :geodata_api, Geodata_api.Repo,
  database: "geodata_api",
  username: "postgres",
  password: "123123",
  hostname: "localhost"
