defmodule LicencaWeb.FormatHelpers do
  def format_document(doc) when is_binary(doc) and byte_size(doc) == 14 do
    Regex.replace(~r/^(\d{2})(\d{3})(\d{3})(\d{4})(\d{2})$/, doc, "\\1.\\2.\\3/\\4-\\5")
  end

  def format_document(doc) when is_binary(doc) and byte_size(doc) == 11 do
    Regex.replace(~r/^(\d{3})(\d{3})(\d{3})(\d{2})$/, doc, "\\1.\\2.\\3-\\4")
  end

  def format_document(doc), do: doc
end
