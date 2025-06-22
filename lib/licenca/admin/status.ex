defmodule Licenca.Admin.Status do
  use Ecto.Schema
  import Ecto.Changeset

  schema "status" do
    field :description, :string

    has_many :empresas, Licenca.Admin.Empresa

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(status, attrs) do
    status
    |> cast(attrs, [:description])
    |> validate_required([:description])
  end
end
