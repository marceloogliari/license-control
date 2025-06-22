defmodule Licenca.Admin.Empresa do
  use Ecto.Schema
  import Ecto.Changeset

  schema "empresas" do
    field :cnpj, :string
    field :name, :string
    field :licenca_fim, :date

    # Essa entidade pertence a outra.
    # Ou seja, tem uma chave estrangeira(foreign key) apontando para outra tabela.
    belongs_to :status, Licenca.Admin.Status

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(empresa, attrs) do
    empresa
    |> cast(attrs, [:cnpj, :name, :status_id, :licenca_fim])
    |> validate_required([:cnpj, :name])
    |> unique_constraint(:cnpj, message: "CNPJ já cadastrado")
    |> validate_flexible_document(:cnpj)
    |> validate_length(:name, min: 2, max: 255)
    |> validate_status_and_date()
    |> validate_change(:licenca_fim, fn :licenca_fim, date ->
      if Date.compare(date, Date.utc_today()) == :lt do
        [licenca_fim: "Deve ser uma data futura"]
      else
        []
      end
    end)
  end

  # Validação condicional baseada no status_id
  defp validate_status_and_date(changeset) do
    status_id = get_change(changeset, :status_id) || get_field(changeset, :status_id)
    licenca_fim = get_change(changeset, :licenca_fim) || get_field(changeset, :licenca_fim)

    case status_id do
      1 ->
        put_change(changeset, :licenca_fim, nil)

      status when status in [2, 3, 4] ->
        if is_nil(licenca_fim) do
          add_error(
            changeset,
            :licenca_fim,
            "Data de licença é obrigatória."
          )
        else
          changeset
        end

      _ ->
        changeset
    end
  end

  defp validate_flexible_document(changeset, field) do
    validate_change(changeset, field, fn field, value ->
      # Remove formatação (pontos, traços, barras)
      clean_value = String.replace(to_string(value), ~r/[^\d]/, "")

      cond do
        String.length(clean_value) == 11 and valid_cpf?(clean_value) ->
          []

        String.length(clean_value) == 14 and valid_cnpj?(clean_value) ->
          []

        String.length(clean_value) == 11 ->
          [{field, "CPF inválido!"}]

        String.length(clean_value) == 14 ->
          [{field, "CNPJ inválido!"}]

        true ->
          [{field, "Deve ser um CPF (11 dígitos) ou CNPJ (14 dígitos) válido"}]
      end
    end)
  end

  # Função para validar CPF
  defp valid_cpf?(cpf) when byte_size(cpf) == 11 do
    # Verifica se todos os dígitos são iguais
    if Regex.match?(~r/^(\d)\1{10}$/, cpf) do
      false
    else
      digits = String.graphemes(cpf) |> Enum.map(&String.to_integer/1)

      # Calcula primeiro dígito verificador
      sum1 =
        digits
        |> Enum.take(9)
        |> Enum.with_index()
        |> Enum.reduce(0, fn {digit, index}, acc ->
          acc + digit * (10 - index)
        end)

      digit1 = rem(sum1 * 10, 11)
      digit1 = if digit1 == 10, do: 0, else: digit1

      # Calcula segundo dígito verificador
      sum2 =
        digits
        |> Enum.take(10)
        |> Enum.with_index()
        |> Enum.reduce(0, fn {digit, index}, acc ->
          acc + digit * (11 - index)
        end)

      digit2 = rem(sum2 * 10, 11)
      digit2 = if digit2 == 10, do: 0, else: digit2

      # Verifica se os dígitos calculados coincidem
      Enum.at(digits, 9) == digit1 and Enum.at(digits, 10) == digit2
    end
  end

  defp valid_cpf?(_), do: false

  # Função para validar CNPJ
  defp valid_cnpj?(cnpj) when byte_size(cnpj) == 14 do
    # Verifica se todos os dígitos são iguais
    if Regex.match?(~r/^(\d)\1{13}$/, cnpj) do
      false
    else
      digits = String.graphemes(cnpj) |> Enum.map(&String.to_integer/1)

      # Pesos para primeiro dígito verificador
      weights1 = [5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

      # Calcula primeiro dígito verificador
      sum1 =
        digits
        |> Enum.take(12)
        |> Enum.zip(weights1)
        |> Enum.reduce(0, fn {digit, weight}, acc ->
          acc + digit * weight
        end)

      digit1 = rem(sum1, 11)
      digit1 = if digit1 < 2, do: 0, else: 11 - digit1

      # Pesos para segundo dígito verificador
      weights2 = [6, 5, 4, 3, 2, 9, 8, 7, 6, 5, 4, 3, 2]

      # Calcula segundo dígito verificador
      sum2 =
        digits
        |> Enum.take(13)
        |> Enum.zip(weights2)
        |> Enum.reduce(0, fn {digit, weight}, acc ->
          acc + digit * weight
        end)

      digit2 = rem(sum2, 11)
      digit2 = if digit2 < 2, do: 0, else: 11 - digit2

      # Verifica se os dígitos calculados coincidem
      Enum.at(digits, 12) == digit1 and Enum.at(digits, 13) == digit2
    end
  end

  defp valid_cnpj?(_), do: false
end
