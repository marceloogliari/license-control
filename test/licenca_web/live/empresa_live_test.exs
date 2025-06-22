defmodule LicencaWeb.EmpresaLiveTest do
  use LicencaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Licenca.AdminFixtures

  @create_attrs %{name: "some name", cnpj: "some cnpj"}
  @update_attrs %{name: "some updated name", cnpj: "some updated cnpj"}
  @invalid_attrs %{name: nil, cnpj: nil}
  defp create_empresa(_) do
    empresa = empresa_fixture()

    %{empresa: empresa}
  end

  describe "Index" do
    setup [:create_empresa]

    test "lists all empresas", %{conn: conn, empresa: empresa} do
      {:ok, _index_live, html} = live(conn, ~p"/empresas")

      assert html =~ "Listing Empresas"
      assert html =~ empresa.cnpj
    end

    test "saves new empresa", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/empresas")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Empresa")
               |> render_click()
               |> follow_redirect(conn, ~p"/empresas/new")

      assert render(form_live) =~ "New Empresa"

      assert form_live
             |> form("#empresa-form", empresa: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#empresa-form", empresa: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/empresas")

      html = render(index_live)
      assert html =~ "Empresa created successfully"
      assert html =~ "some cnpj"
    end

    test "updates empresa in listing", %{conn: conn, empresa: empresa} do
      {:ok, index_live, _html} = live(conn, ~p"/empresas")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#empresas-#{empresa.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/empresas/#{empresa}/edit")

      assert render(form_live) =~ "Edit Empresa"

      assert form_live
             |> form("#empresa-form", empresa: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#empresa-form", empresa: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/empresas")

      html = render(index_live)
      assert html =~ "Empresa updated successfully"
      assert html =~ "some updated cnpj"
    end

    test "deletes empresa in listing", %{conn: conn, empresa: empresa} do
      {:ok, index_live, _html} = live(conn, ~p"/empresas")

      assert index_live |> element("#empresas-#{empresa.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#empresas-#{empresa.id}")
    end
  end

  describe "Show" do
    setup [:create_empresa]

    test "displays empresa", %{conn: conn, empresa: empresa} do
      {:ok, _show_live, html} = live(conn, ~p"/empresas/#{empresa}")

      assert html =~ "Show Empresa"
      assert html =~ empresa.cnpj
    end

    test "updates empresa and returns to show", %{conn: conn, empresa: empresa} do
      {:ok, show_live, _html} = live(conn, ~p"/empresas/#{empresa}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/empresas/#{empresa}/edit?return_to=show")

      assert render(form_live) =~ "Edit Empresa"

      assert form_live
             |> form("#empresa-form", empresa: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#empresa-form", empresa: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/empresas/#{empresa}")

      html = render(show_live)
      assert html =~ "Empresa updated successfully"
      assert html =~ "some updated cnpj"
    end
  end
end
