defmodule LicencaWeb.EmpresaLive.Index do
  use LicencaWeb, :live_view

  alias Licenca.Admin

  # import LicencaWeb.FormatHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        <:actions>
          <.button variant="primary" navigate={~p"/empresas/new"}>
            <.icon name="hero-plus" /> Adicionar
          </.button>
        </:actions>
      </.header>

      <.form
        for={@form}
        id="filtros-form"
        as={:filtros}
        phx-change="filtrar"
        phx-submit="filtrar"
        class="grid grid-cols-2 gap-2"
      >
        <.input field={@form[:busca]} type="text" label="Nome, CPF ou CNPJ" phx-debounce="300" />
        <.input
          field={@form[:status_id]}
          type="select"
          label="Status"
          options={[{"Todos", ""} | Enum.map(@lista_status, &{&1.description, &1.id})]}
        />
      </.form>

      <.table
        id="empresas"
        rows={@streams.empresas}
        row_click={fn {_id, empresa} -> JS.navigate(~p"/empresas/#{empresa}/edit") end}
      >
        <:col :let={{_id, empresa}} label="Código">#000{empresa.id}</:col>
        <!-- <:col :let={{_id, empresa}} label="CNPJ/CPF">{format_document(empresa.cnpj)}</:col> -->
        <:col :let={{_id, empresa}} label="Name">{empresa.name}</:col>

        <:col :let={{_id, empresa}} label="Status">
          {case empresa.status do
            nil -> "Sem status"
            status -> status.description
          end}
        </:col>

        <:col :let={{_id, empresa}} label="Licença">
          {case empresa.licenca_fim do
            nil -> "--"
            _ -> Calendar.strftime(empresa.licenca_fim, "%d/%m/%Y")
          end}
        </:col>

        <:action :let={{_id, empresa}}>
          <!--<div class="sr-only">
            <.link navigate={~p"/empresas/#{empresa}"}>
              Show
            </.link>
          </div>-->

          <.link
            navigate={~p"/empresas/#{empresa}/edit"}
            class="inline-flex items-center gap-1 hover:text-sky-600"
          >
            <.icon name="hero-pencil-square" class="w-5 h-5" />
          </.link>
        </:action>
        <:action :let={{id, empresa}}>
          <.link
            phx-click={JS.push("delete", value: %{id: empresa.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
            class="inline-flex items-center gap-1 hover:text-rose-700"
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
    filtros = %{"busca" => "", "status_id" => "", "licenca_fim" => ""}

    {:ok,
     socket
     |> assign(:page_title, "Lista de Empresas")
     |> assign(:filtros, filtros)
     |> assign(:form, to_form(filtros, as: :filtros))
     |> assign(:lista_status, Admin.list_status())
     |> stream(:empresas, Admin.list_empresas_filtro(filtros))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    empresa = Admin.get_empresa!(id)
    {:ok, _} = Admin.delete_empresa(empresa)

    {:noreply, stream_delete(socket, :empresas, empresa)}
  end

  @impl true
  def handle_event("filtrar", %{"filtros" => filtros}, socket) do
    empresas = Admin.list_empresas_filtro(filtros)

    {:noreply,
     socket
     |> assign(:filtros, filtros)
     |> assign(:form, to_form(filtros, as: :filtros))
     |> stream(:empresas, empresas, reset: true)}
  end
end
