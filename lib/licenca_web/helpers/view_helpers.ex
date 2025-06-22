defmodule LicencaWeb.Helpers.ViewHelpers do
  def t(key, bindings \\ %{}) do
    Gettext.gettext(LicencaWeb.Gettext, key, bindings)
  end

  def tn(singular, plural, count, bindings \\ %{}) do
    Gettext.ngettext(LicencaWeb.Gettext, singular, plural, count, bindings)
  end
end
