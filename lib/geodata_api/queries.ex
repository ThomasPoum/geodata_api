defmodule GeodataApi.Queries do

  def check_query(conn) do
    longitude = Map.get(conn.query_params, "longitude")
    latitude = Map.get(conn.query_params, "latitude")
    radius = Map.get(conn.query_params, "radius")

    # Vérifier si les paramètres sont présents
    unless is_binary(longitude) and is_binary(latitude) and is_binary(radius) do
       {:error, "Les paramètres de requête sont invalides."}
    else
      # Vérifier si les paramètres ont le bon format
      unless parse_float(longitude) != nil and parse_float(latitude) != nil and parse_float(radius) != nil do
         {:error, "Les paramètres de requête doivent être des valeurs numériques."}
      else
        # Vérifier si les paramètres sont dans la plage attendue, le cas échéant
        unless parse_float(longitude) >= -180.0 and parse_float(longitude) <= 180.0 do
           {:error, "La longitude doit être comprise entre -180 et 180."}
        else
          # Autres vérifications de validité des paramètres de requête

          # Si toutes les vérifications passent, retourner :ok
           {:ok, conn.query_params}
        end
      end
    end
  end

  defp parse_float(value) do
    case Float.parse(value) do
      {float, _} -> float
      _ -> nil
    end
  end
end
