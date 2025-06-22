defmodule LicencaWeb.EmpresaLive.Form do
  use LicencaWeb, :live_view

  alias Licenca.Admin
  alias Licenca.Admin.Empresa

  # import LicencaWeb.FormatHelpers

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        {t(@page_title)}
      </.header>

      <.form for={@form} id="empresa-form" phx-change="validate" phx-submit="save">
        <div class="grid gap-4">
          <.input field={@form[:cnpj]} type="text" placeholder="CNPJ/CPF" label="CNPJ/CPF" />
          <.input field={@form[:name]} type="text" label={t("Name")} />

          <.input
            field={@form[:status_id]}
            type="select"
            label={t("Status")}
            options={Enum.map(@lista_status, &{&1.description, &1.id})}
          />

          <.input field={@form[:licenca_fim]} type="date" label={t("Date License")} />
        </div>
        <footer class="mt-4">
          <.button phx-disable-with="Saving..." variant="primary">Salvar</.button>
          <.button navigate={return_path(@return_to, @empresa)}>Cancelar</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    lista_status = Admin.list_status()

    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> assign(:lista_status, lista_status)
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    empresa = Admin.get_empresa!(id)

    socket
    |> assign(:page_title, "Edit Company")
    |> assign(:empresa, empresa)
    |> assign(:form, to_form(Admin.change_empresa(empresa)))
  end

  defp apply_action(socket, :new, _params) do
    empresa = %Empresa{}

    socket
    |> assign(:page_title, "Register Company")
    |> assign(:empresa, empresa)
    |> assign(:form, to_form(Admin.change_empresa(empresa)))
  end

  @impl true
  def handle_event("validate", %{"empresa" => empresa_params}, socket) do
    changeset = Admin.change_empresa(socket.assigns.empresa, empresa_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"empresa" => empresa_params}, socket) do
    save_empresa(socket, socket.assigns.live_action, empresa_params)
  end

  defp save_empresa(socket, :edit, empresa_params) do
    case Admin.update_empresa(socket.assigns.empresa, empresa_params) do
      {:ok, empresa} ->
        {:noreply,
         socket
         |> put_flash(:info, t("Company changed successfully."))
         |> push_navigate(to: return_path(socket.assigns.return_to, empresa))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_empresa(socket, :new, empresa_params) do
    case Admin.create_empresa(empresa_params) do
      {:ok, empresa} ->
        {:noreply,
         socket
         |> put_flash(:info, "Company successfully registered.")
         |> push_navigate(to: return_path(socket.assigns.return_to, empresa))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _empresa), do: ~p"/empresas"
  # defp return_path("show", empresa), do: ~p"/empresas/#{empresa}"
end
