defmodule Licenca.Repo.Migrations.CreateStatus do
  use Ecto.Migration

  def change do
    create table(:status) do
      add :description, :string

      timestamps(type: :utc_datetime)
    end
  end
end
