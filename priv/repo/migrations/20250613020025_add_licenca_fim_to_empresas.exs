defmodule Licenca.Repo.Migrations.AddLicencaFimToEmpresas do
  use Ecto.Migration

  def change do
    alter table(:empresas) do
      add :licenca_fim, :date
    end
  end
end
