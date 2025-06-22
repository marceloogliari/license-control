defmodule LicencaWeb.EmpresaController do
  use LicencaWeb, :controller
  alias Licenca.Admin

  def por_cnpj(conn, %{"cnpj" => cnpj}) do
    case Admin.get_empresa_info_por_cnpj!(cnpj) do
      nil ->
        conn
        |> put_status(:not_found)
        |> json(%{
          erro:
            "CNPJ/CPF não cadastrado no servidor do sistema, entrar em contato com o administrador do sistema."
        })

      empresa ->
        # Retorna só o nome, ou o que quiser
        # json(conn, %{status_id: empresa.status_id, message: "Empresa encontrada"})
        json(conn, empresa)
    end
  end
end
