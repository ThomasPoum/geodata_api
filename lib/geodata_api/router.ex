defmodule GeodataApi.Router do
  # Bring Plug.Router module into scope
  use Plug.Router

  alias Geodata_api.Repo

  alias GeodataApi.CarreauxController

  # Attach the Logger to log incoming requests
  plug(Plug.Logger)

  # Tell Plug to match the incoming request with the defined endpoints
  plug(:match)

  # Once there is a match, parse the response body if the content-type
  # is application/json. The order is important here, as we only want to
  # parse the body if there is a matching route.(Using the Jayson parser)
  plug(Plug.Parsers,
    parsers: [:json],
    pass: ["application/json"],
    json_decoder: Jason
  )

  # Checks the token
  plug(GeodataApi.TokenAuth)

  # Dispatch the connection to the matched handler
  plug(:dispatch)

  # Handler for GET request with "/" path
  get "/" do
    send_resp(conn, 200, "OK")
  end

  get "/test" do
    case Repo.get_dynamic_repo() do
      Geodata_api.Repo -> send_resp(conn, 200, "OK" <> to_string(Geodata_api.Repo))
      _ -> send_resp(conn, 404, "Not Found")
    end
  end

  get "carreaux/search" do
    CarreauxController.search(conn)
  end

  # Fallback handler when there was no match
  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
