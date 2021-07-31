defmodule Backcaster.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Backcaster.Repo,
      # Start the Telemetry supervisor
      BackcasterWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Backcaster.PubSub},
      # Start the Endpoint (http/https)
      BackcasterWeb.Endpoint
      # Start a worker by calling: Backcaster.Worker.start_link(arg)
      # {Backcaster.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Backcaster.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    BackcasterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
