defmodule LicencaWeb.EmpresaLive.Show do
  use LicencaWeb, :live_view

  alias Licenca.Admin
  import LicencaWeb.FormatHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        <:actions>
          <.button navigate={~p"/empresas"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button variant="primary" navigate={~p"/empresas/#{@empresa}/edit?return_to=show"}>
            <.icon name="hero-pencil-square" /> Editar
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Código">#000{@empresa.id}</:item>
        <:item title="CNPJ/CPF">{format_document(@empresa.cnpj)}</:item>
        <:item title="Name">{@empresa.name}</:item>
        <:item title="Status">
          {case @empresa.status do
            nil -> "Sem status"
            status -> status.description
          end}
        </:item>

        <:item title="Data Licença">
          {case @empresa.licenca_fim do
            nil -> "--/--/----"
            _ -> Calendar.strftime(@empresa.licenca_fim, "%d/%m/%Y")
          end}
        </:item>
      </.list>
    </Layouts.app>
    """
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Show Empresa")
     |> assign(:empresa, Admin.get_empresa!(id))}
  end
end
