defmodule GeodataApi.CarreauxController do
  import Plug.Conn
  alias GeodataApi.Carreaux.Carreaux
  # alias GeodataApi.Tokens.Tokens
  alias GeodataApi.Queries

  def search(conn) do
    case Queries.check_query(conn) do
      {:ok, query_params} ->
        # Récupérer les paramètres de la requête
        longitude = Map.get(query_params, "longitude", 0.0) |> String.to_float()
        latitude = Map.get(query_params, "latitude", 0.0) |> String.to_float()
        radius = Map.get(query_params, "radius", 0.0) |> String.to_float()

        # Appeler la fonction du contexte Carreaux pour récupérer les carreaux dans le rayon
        carreaux = Carreaux.get_carreaux_in_radius_2(latitude, longitude, radius)

        # Exemple de résultat
        result = %{result: carreaux}

        conn
        |> put_resp_content_type("application/json")
        |> send_resp(200, Jason.encode!(result))

      {:error, error_message} ->
        conn
        |> put_resp_content_type("application/json")
        |> send_resp(400, Jason.encode!(%{error: error_message}))
        |> halt()
    end
  end
end
