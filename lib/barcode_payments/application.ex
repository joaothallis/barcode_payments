defmodule BarcodePayments.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      BarcodePaymentsWeb.Telemetry,
      {DNSCluster, query: Application.get_env(:barcode_payments, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: BarcodePayments.PubSub},
      # Start a worker by calling: BarcodePayments.Worker.start_link(arg)
      # {BarcodePayments.Worker, arg},
      # Start to serve requests, typically the last entry
      BarcodePaymentsWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: BarcodePayments.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BarcodePaymentsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
