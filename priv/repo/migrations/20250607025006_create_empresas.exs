defmodule Licenca.Repo.Migrations.CreateEmpresas do
  use Ecto.Migration

  def change do
    create table(:empresas) do
      add :cnpj, :string
      add :name, :string
      add :status_id, references(:status, on_delete: :nothing)

      timestamps(type: :utc_datetime)
    end

    create index(:empresas, [:status_id])
    create unique_index(:empresas, [:cnpj])
  end
end
