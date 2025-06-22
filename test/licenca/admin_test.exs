defmodule Licenca.AdminTest do
  use Licenca.DataCase

  alias Licenca.Admin

  describe "status" do
    alias Licenca.Admin.Status

    import Licenca.AdminFixtures

    @invalid_attrs %{description: nil}

    test "list_status/0 returns all status" do
      status = status_fixture()
      assert Admin.list_status() == [status]
    end

    test "get_status!/1 returns the status with given id" do
      status = status_fixture()
      assert Admin.get_status!(status.id) == status
    end

    test "create_status/1 with valid data creates a status" do
      valid_attrs = %{description: "some description"}

      assert {:ok, %Status{} = status} = Admin.create_status(valid_attrs)
      assert status.description == "some description"
    end

    test "create_status/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_status(@invalid_attrs)
    end

    test "update_status/2 with valid data updates the status" do
      status = status_fixture()
      update_attrs = %{description: "some updated description"}

      assert {:ok, %Status{} = status} = Admin.update_status(status, update_attrs)
      assert status.description == "some updated description"
    end

    test "update_status/2 with invalid data returns error changeset" do
      status = status_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_status(status, @invalid_attrs)
      assert status == Admin.get_status!(status.id)
    end

    test "delete_status/1 deletes the status" do
      status = status_fixture()
      assert {:ok, %Status{}} = Admin.delete_status(status)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_status!(status.id) end
    end

    test "change_status/1 returns a status changeset" do
      status = status_fixture()
      assert %Ecto.Changeset{} = Admin.change_status(status)
    end
  end

  describe "empresas" do
    alias Licenca.Admin.Empresa

    import Licenca.AdminFixtures

    @invalid_attrs %{name: nil, cnpj: nil}

    test "list_empresas/0 returns all empresas" do
      empresa = empresa_fixture()
      assert Admin.list_empresas() == [empresa]
    end

    test "get_empresa!/1 returns the empresa with given id" do
      empresa = empresa_fixture()
      assert Admin.get_empresa!(empresa.id) == empresa
    end

    test "create_empresa/1 with valid data creates a empresa" do
      valid_attrs = %{name: "some name", cnpj: "some cnpj"}

      assert {:ok, %Empresa{} = empresa} = Admin.create_empresa(valid_attrs)
      assert empresa.name == "some name"
      assert empresa.cnpj == "some cnpj"
    end

    test "create_empresa/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Admin.create_empresa(@invalid_attrs)
    end

    test "update_empresa/2 with valid data updates the empresa" do
      empresa = empresa_fixture()
      update_attrs = %{name: "some updated name", cnpj: "some updated cnpj"}

      assert {:ok, %Empresa{} = empresa} = Admin.update_empresa(empresa, update_attrs)
      assert empresa.name == "some updated name"
      assert empresa.cnpj == "some updated cnpj"
    end

    test "update_empresa/2 with invalid data returns error changeset" do
      empresa = empresa_fixture()
      assert {:error, %Ecto.Changeset{}} = Admin.update_empresa(empresa, @invalid_attrs)
      assert empresa == Admin.get_empresa!(empresa.id)
    end

    test "delete_empresa/1 deletes the empresa" do
      empresa = empresa_fixture()
      assert {:ok, %Empresa{}} = Admin.delete_empresa(empresa)
      assert_raise Ecto.NoResultsError, fn -> Admin.get_empresa!(empresa.id) end
    end

    test "change_empresa/1 returns a empresa changeset" do
      empresa = empresa_fixture()
      assert %Ecto.Changeset{} = Admin.change_empresa(empresa)
    end
  end
end
