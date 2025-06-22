defmodule Licenca.AdminFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Licenca.Admin` context.
  """

  @doc """
  Generate a status.
  """
  def status_fixture(attrs \\ %{}) do
    {:ok, status} =
      attrs
      |> Enum.into(%{
        description: "some description"
      })
      |> Licenca.Admin.create_status()

    status
  end

  @doc """
  Generate a empresa.
  """
  def empresa_fixture(attrs \\ %{}) do
    {:ok, empresa} =
      attrs
      |> Enum.into(%{
        cnpj: "some cnpj",
        name: "some name"
      })
      |> Licenca.Admin.create_empresa()

    empresa
  end
end
