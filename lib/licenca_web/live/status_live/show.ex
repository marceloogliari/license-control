defmodule LicencaWeb.StatusLive.Show do
  use LicencaWeb, :live_view

  alias Licenca.Admin

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        <:actions>
          <.button navigate={~p"/status"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/status/#{@status}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Editar
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Código">#000{@status.id}</:item>
        <:item title="Descrição">{@status.description}</:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Status")
     |> assign(:status, Admin.get_status!(id))}
  end
end
