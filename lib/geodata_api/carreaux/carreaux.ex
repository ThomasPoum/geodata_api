defmodule GeodataApi.Carreaux.Carreaux do
  @moduledoc """
  Ce module contient les fonctions de manipulation des données des carreaux.
  """

  import Ecto.Query
  alias Geodata_api.Repo
  alias GeodataApi.Schemas.Carreau

  @doc """
  Retourne un carreau en fonction de son id.

  ## Examples

      iex> GeodataApi.Carreaux.Carreaux.get_carreau("1234")
      %Carreaux{...}

  """
  def get_carreau(id) do
    Repo.get(Carreau, id)
    |> Jason.encode!()
  end

  @doc """
  Retourne tous les carreaux.

  ## Examples

      iex> GeodataApi.Carreaux.Carreaux.get_all_carreaux()
      [%Carreaux{...}, %Carreaux{...}]

  """
  def get_all_carreaux() do
    Repo.all(Carreau)
    |> Enum.to_list()
    |> Jason.encode!()
  end

  @doc """
  Retourne tous les carreaux dont l'indicateur est supérieur ou égal à la valeur donnée.

  ## Examples

      iex> GeodataApi.Carreaux.Carreaux.get_carreaux(10.5)
      [%Carreaux{...}, %Carreaux{...}]

  """
  def get_carreaux(value) do
    q = from(c in Carreau, where: c.ind >= ^value)
    Repo.all(q)
  end

  @doc """
  Compte le nombre de carreaux dont l'indicateur est supérieur ou égal à la valeur donnée.

  ## Examples

      iex> GeodataApi.Carreaux.Carreaux.count_carreaux(%{"value" => "10.5"})
      "2"

  """
  def count_carreaux(query_params) do
    {value, _} =
      query_params
      |> Map.values()
      |> Enum.at(0)
      |> Float.parse()

    get_carreaux(value)
    |> Enum.count()
    |> Jason.encode!()
  end



  def get_carreaux_in_radius_2(latitude, longitude, radius_km) do
    # Convert the radius from kilometers to degrees
    radius_in_degrees = radius_km / 111.045

    # Define the size of the square in degrees (200m in degrees)
    square_size_in_degrees = 200.0 / 111_045.0

    # Define a query for the database
    query =
      from(c in Carreau,
        # Check if the center of the square is within the radius
        where:
          fragment(
            "? >= ? - ? and ? <= ? + ? and
                      ? >= ? - ? and ? <= ? + ?",
            c.latitude + ^square_size_in_degrees / 2.0,
            type(^latitude, :float),
            type(^radius_in_degrees, :float),
            c.latitude + ^square_size_in_degrees / 2.0,
            type(^latitude, :float),
            type(^radius_in_degrees, :float),
            c.longitude + ^square_size_in_degrees / 2.0,
            type(^longitude, :float),
            type(^radius_in_degrees, :float),
            c.longitude + ^square_size_in_degrees / 2.0,
            type(^longitude, :float),
            type(^radius_in_degrees, :float)
          )
      )

    # Execute the query
    result =
      Repo.all(query)
      # |> Enum.to_list()
      |> Enum.reduce(0, fn x, acc ->
        acc + x.ind
      end)


  end
end
