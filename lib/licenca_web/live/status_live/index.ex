defmodule LicencaWeb.StatusLive.Index do
  use LicencaWeb, :live_view

  alias Licenca.Admin

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Lista de Status
        <:actions>
          <.button variant="primary" navigate={~p"/status/new"}>
            <.icon name="hero-plus" /> Adicionar
          </.button>
        </:actions>
      </.header>

      <.table
        id="status"
        rows={@streams.status_collection}
        row_click={fn {_id, status} -> JS.navigate(~p"/status/#{status}") end}
      >
        <:col :let={{_id, status}} label="Código">#000{status.id}</:col>
        <:col :let={{_id, status}} label="Descrição">{status.description}</:col>
        <:action :let={{_id, status}}>
          <div class="sr-only">
            <.link navigate={~p"/status/#{status}"}>Show</.link>
          </div>
          <.link
            navigate={~p"/status/#{status}/edit"}
            class="inline-flex items-center gap-1 hover:text-blue-800"
          >
            <.icon name="hero-pencil-square" class="w-5 h-5" />
          </.link>
        </:action>
        <:action :let={{id, status}}>
          <.link
            phx-click={JS.push("delete", value: %{id: status.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
            class="inline-flex items-center gap-1 hover:text-red-800"
          >
            <.icon name="hero-trash" class="w-5 h-5" />
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Listing Status")
     |> stream(:status_collection, Admin.list_status())}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    status = Admin.get_status!(id)
    {:ok, _} = Admin.delete_status(status)

    {:noreply, stream_delete(socket, :status_collection, status)}
  end
end
