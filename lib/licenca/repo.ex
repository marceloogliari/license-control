defmodule Licenca.Repo do
  use Ecto.Repo,
    otp_app: :licenca,
    adapter: Ecto.Adapters.Postgres
end
