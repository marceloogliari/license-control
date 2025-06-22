defmodule LicencaWeb.StatusLive.Form do
  use LicencaWeb, :live_view

  alias Licenca.Admin
  alias Licenca.Admin.Status

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash}>
      <.header>
        Cadastro Status
      </.header>

      <.form for={@form} id="status-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:description]} type="text" label="Descrição" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Salvar</.button>
          <.button navigate={return_path(@return_to, @status)}>Cancelar</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    status = Admin.get_status!(id)

    socket
    |> assign(:page_title, "Edit Status")
    |> assign(:status, status)
    |> assign(:form, to_form(Admin.change_status(status)))
  end

  defp apply_action(socket, :new, _params) do
    status = %Status{}

    socket
    |> assign(:page_title, "New Status")
    |> assign(:status, status)
    |> assign(:form, to_form(Admin.change_status(status)))
  end

  @impl true
  def handle_event("validate", %{"status" => status_params}, socket) do
    changeset = Admin.change_status(socket.assigns.status, status_params)
    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"status" => status_params}, socket) do
    save_status(socket, socket.assigns.live_action, status_params)
  end

  defp save_status(socket, :edit, status_params) do
    case Admin.update_status(socket.assigns.status, status_params) do
      {:ok, status} ->
        {:noreply,
         socket
         |> put_flash(:info, "Status updated successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, status))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_status(socket, :new, status_params) do
    case Admin.create_status(status_params) do
      {:ok, status} ->
        {:noreply,
         socket
         |> put_flash(:info, "Status created successfully")
         |> push_navigate(to: return_path(socket.assigns.return_to, status))}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path("index", _status), do: ~p"/status"
  defp return_path("show", status), do: ~p"/status/#{status}"
end
