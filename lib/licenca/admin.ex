defmodule Licenca.Admin do
  @moduledoc """
  The Admin context.
  """

  import Ecto.Query, warn: false
  alias Licenca.Repo

  alias Licenca.Admin.Status

  @doc """
  Returns the list of status.

  ## Examples

      iex> list_status()
      [%Status{}, ...]

  """
  def list_status do
    Repo.all(Status)
  end

  @doc """
  Gets a single status.

  Raises `Ecto.NoResultsError` if the Status does not exist.

  ## Examples

      iex> get_status!(123)
      %Status{}

      iex> get_status!(456)
      ** (Ecto.NoResultsError)

  """
  def get_status!(id), do: Repo.get!(Status, id)

  @doc """
  Creates a status.

  ## Examples

      iex> create_status(%{field: value})
      {:ok, %Status{}}

      iex> create_status(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_status(attrs) do
    %Status{}
    |> Status.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a status.

  ## Examples

      iex> update_status(status, %{field: new_value})
      {:ok, %Status{}}

      iex> update_status(status, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_status(%Status{} = status, attrs) do
    status
    |> Status.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a status.

  ## Examples

      iex> delete_status(status)
      {:ok, %Status{}}

      iex> delete_status(status)
      {:error, %Ecto.Changeset{}}

  """
  def delete_status(%Status{} = status) do
    Repo.delete(status)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking status changes.

  ## Examples

      iex> change_status(status)
      %Ecto.Changeset{data: %Status{}}

  """
  def change_status(%Status{} = status, attrs \\ %{}) do
    Status.changeset(status, attrs)
  end

  alias Licenca.Admin.Empresa

  @doc """
  Returns the list of empresas.

  ## Examples

      iex> list_empresas()
      [%Empresa{}, ...]

  """
  def list_empresas do
    # from(e in Empresa, preload: [:status]) |> Repo.all()
    Repo.all(Empresa)
    |> Repo.preload(:status)
  end

  @doc """
  Gets a single empresa.

  Raises `Ecto.NoResultsError` if the Empresa does not exist.

  ## Examples

      iex> get_empresa!(123)
      %Empresa{}

      iex> get_empresa!(456)
      ** (Ecto.NoResultsError)

  """
  def get_empresa!(id) do
    Repo.get!(Empresa, id)
    |> Repo.preload(:status)
  end

  def get_empresa_with_associations!(id) do
    Repo.get!(Empresa, id)
    |> Repo.preload(:status)
  end

  def get_empresa_cnpj!(cnpj) do
    Repo.get_by(Empresa, cnpj: cnpj)
    |> Repo.preload(:status)
  end

  def get_empresa_info_por_cnpj!(cnpj) do
    with %Empresa{} = empresa <- Repo.get_by(Empresa, cnpj: cnpj) do
      dias =
        cond do
          empresa.status_id == 2 -> max(Date.diff(empresa.licenca_fim, Date.utc_today()), 0)
          true -> 0
        end

      status_final =
        cond do
          empresa.status_id == 2 and dias == 0 -> 3
          true -> empresa.status_id
        end

      mensagem =
        case status_final do
          1 ->
            ""

          2 ->
            "Existe fatura em aberto, restam #{dias} dias de acesso. Caso o pagamento já tenha sido realizado, por favor desconcidere este aviso."

          3 ->
            "Autenticação negada. Existe fatura em aberto para este CNPJ/CPF, caso o pagamento ja tenha sido efetuado entrar em contato com o administrador do sistema."

          4 ->
            "CNPJ/CPF desativado no servidor do sistema."

          _ ->
            "CNPJ/CPF não cadastrado no servidor do sistema, entrar em contato com o administrador do sistema."
        end

      %{
        status_id: status_final,
        mensagem: mensagem,
        dias: dias
      }
    else
      _ -> nil
    end
  end

  @doc """
  Creates a empresa.

  ## Examples

      iex> create_empresa(%{field: value})
      {:ok, %Empresa{}}

      iex> create_empresa(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_empresa(attrs) do
    %Empresa{}
    |> Empresa.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a empresa.

  ## Examples

      iex> update_empresa(empresa, %{field: new_value})
      {:ok, %Empresa{}}

      iex> update_empresa(empresa, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_empresa(%Empresa{} = empresa, attrs) do
    empresa
    |> Empresa.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a empresa.

  ## Examples

      iex> delete_empresa(empresa)
      {:ok, %Empresa{}}

      iex> delete_empresa(empresa)
      {:error, %Ecto.Changeset{}}

  """
  def delete_empresa(%Empresa{} = empresa) do
    Repo.delete(empresa)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking empresa changes.

  ## Examples

      iex> change_empresa(empresa)
      %Ecto.Changeset{data: %Empresa{}}

  """
  def change_empresa(%Empresa{} = empresa, attrs \\ %{}) do
    Empresa.changeset(empresa, attrs)
  end

  @doc """
  Returns the list of empresas filtered by the given filters.

  ## Examples

      iex> list_empresas_filtro(%{"nome" => "nome", "cnpj" => "cnpj", "status_id" => "status_id", "licenca_fim" => "licenca_fim"})
      [%Empresa{}, ...]

  """
  def list_empresas_filtro(filtros \\ %{}) do
    query =
      Empresa
      |> filtrar_por_busca(filtros["busca"])
      |> filtrar_por_data(filtros["licenca_fim"])
      |> filtrar_por_status(filtros["status_id"])
      |> order_by(asc: :id)
      |> preload([:status])

    Repo.all(query)
  end

  defp filtrar_por_busca(query, nil), do: query
  defp filtrar_por_busca(query, ""), do: query

  defp filtrar_por_busca(query, termo) do
    termo_limpo = String.trim(termo)

    where(
      query,
      [e],
      ilike(e.name, ^"%#{termo_limpo}%") or
        ilike(e.cnpj, ^"%#{termo_limpo}%")
    )
  end

  defp filtrar_por_data(query, nil), do: query
  defp filtrar_por_data(query, ""), do: query

  defp filtrar_por_data(query, data),
    do: where(query, [e], e.licenca_fim == ^Date.from_iso8601!(data))

  defp filtrar_por_status(query, nil), do: query
  defp filtrar_por_status(query, ""), do: query

  defp filtrar_por_status(query, status_id),
    do: where(query, [e], e.status_id == ^String.to_integer(status_id))
end
