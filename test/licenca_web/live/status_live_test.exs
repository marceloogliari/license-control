defmodule LicencaWeb.StatusLiveTest do
  use LicencaWeb.ConnCase

  import Phoenix.LiveViewTest
  import Licenca.AdminFixtures

  @create_attrs %{description: "some description"}
  @update_attrs %{description: "some updated description"}
  @invalid_attrs %{description: nil}
  defp create_status(_) do
    status = status_fixture()

    %{status: status}
  end

  describe "Index" do
    setup [:create_status]

    test "lists all status", %{conn: conn, status: status} do
      {:ok, _index_live, html} = live(conn, ~p"/status")

      assert html =~ "Listing Status"
      assert html =~ status.description
    end

    test "saves new status", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/status")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Status")
               |> render_click()
               |> follow_redirect(conn, ~p"/status/new")

      assert render(form_live) =~ "New Status"

      assert form_live
             |> form("#status-form", status: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#status-form", status: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/status")

      html = render(index_live)
      assert html =~ "Status created successfully"
      assert html =~ "some description"
    end

    test "updates status in listing", %{conn: conn, status: status} do
      {:ok, index_live, _html} = live(conn, ~p"/status")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#status-#{status.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/status/#{status}/edit")

      assert render(form_live) =~ "Edit Status"

      assert form_live
             |> form("#status-form", status: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#status-form", status: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/status")

      html = render(index_live)
      assert html =~ "Status updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes status in listing", %{conn: conn, status: status} do
      {:ok, index_live, _html} = live(conn, ~p"/status")

      assert index_live |> element("#status-#{status.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#status-#{status.id}")
    end
  end

  describe "Show" do
    setup [:create_status]

    test "displays status", %{conn: conn, status: status} do
      {:ok, _show_live, html} = live(conn, ~p"/status/#{status}")

      assert html =~ "Show Status"
      assert html =~ status.description
    end

    test "updates status and returns to show", %{conn: conn, status: status} do
      {:ok, show_live, _html} = live(conn, ~p"/status/#{status}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/status/#{status}/edit?return_to=show")

      assert render(form_live) =~ "Edit Status"

      assert form_live
             |> form("#status-form", status: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#status-form", status: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/status/#{status}")

      html = render(show_live)
      assert html =~ "Status updated successfully"
      assert html =~ "some updated description"
    end
  end
end
