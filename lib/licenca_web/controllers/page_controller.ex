defmodule LicencaWeb.PageController do
  use LicencaWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
