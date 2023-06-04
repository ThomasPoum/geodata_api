defmodule Geodata_api.Repo.Migrations.CreateTableFromTokens do
  use Ecto.Migration

  def change do
    create table(:tokens) do
      add :token, :string

      timestamps()
    end

  end
end
