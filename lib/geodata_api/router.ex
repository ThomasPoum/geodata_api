defmodule GeodataApi.Router do
  # Bring Plug.Router module into scope
  use Plug.Router

  alias Geodata_api.Repo
  alias GeodataApi.Carreaux.Carreaux
  alias GeodataApi.Tokens.Tokens

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

    # send_resp(conn, 200, "OK")
  end

  get "/list" do
    carreaux = Carreaux.get_all_carreaux()

    conn
    |> put_resp_content_type("application/json")
    # Send a 200 OK response with the posts in the body
    |> send_resp(200, carreaux)
  end

  get "carreaux/:token/search" do
    token = token_param(conn)

    if Tokens.token_exists?(token) do
      # Récupérer les paramètres de la requête
      longitude = Map.get(conn.query_params, "longitude", 0.0) |> String.to_float()
      latitude = Map.get(conn.query_params, "latitude", 0.0) |> String.to_float()
      radius = Map.get(conn.query_params, "radius", 0.0) |> String.to_float()

      # Appeler la fonction du contexte Carreaux pour récupérer les carreaux dans le rayon
      carreaux = Carreaux.get_carreaux_in_radius_2(latitude, longitude, radius)

      # Exemple de résultat
      test = %{result: carreaux}

      conn
      |> put_resp_content_type("application/json")
      |> send_resp(200, Jason.encode!(test))
    else
      conn
      |> put_resp_content_type("application/json")
      |> send_resp(401, Jason.encode!("not auth"))
    end
  end

  defp token_param(conn) do
    conn.path_params["token"]
  end

  # get "carreaux/search/:token/" do

  #   IO.inspect(token)

  #   if Tokens.token_exists?(token) do
  #     # Récupérer les paramètres de la requête
  #     longitude = Map.get(conn.query_params, "longitude", 0.0) |> String.to_float()
  #     latitude = Map.get(conn.query_params, "latitude", 0.0) |> String.to_float()
  #     radius = Map.get(conn.query_params, "radius", 0.0) |> String.to_float()

  #     # Appeler la fonction du contexte Carreaux pour récupérer les carreaux dans le rayon
  #     carreaux =
  #       GeodataApi.Carreaux.Carreaux.get_carreaux_in_radius_2(latitude, longitude, radius)

  #     # Exemple de résultat
  #     test = %{result: carreaux}

  #     conn
  #     |> put_resp_content_type("application/json")
  #     |> send_resp(200, Jason.encode!(test))
  #   else
  #     conn
  #     |> put_resp_content_type("application/json")
  #     |> send_resp(401, %{error: "Unauthorized"})
  #   end
  # end

  get "carreau/:id" do
    carreau = Carreaux.get_carreau(id)

    conn
    |> put_resp_content_type("application/json")
    # Send a 200 OK response with the posts in the body
    |> send_resp(200, carreau)
  end

  # Fallback handler when there was no match
  match _ do
    send_resp(conn, 404, "Not Found")
  end
end
