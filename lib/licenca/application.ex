defmodule Licenca.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      LicencaWeb.Telemetry,
      Licenca.Repo,
      {DNSCluster, query: Application.get_env(:licenca, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Licenca.PubSub},
      {Finch, name: Licenca.Finch},
      # Start a worker by calling: Licenca.Worker.start_link(arg)
      # {Licenca.Worker, arg},
      # Start to serve requests, typically the last entry
      LicencaWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Licenca.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    LicencaWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
