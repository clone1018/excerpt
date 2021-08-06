defmodule Excerpt.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port = 6667

    children = [
      {Registry, keys: :unique, name: Excerpt.Users},
      Supervisor.child_spec({Task, fn -> Excerpt.ConnectionManager.accept(port) end},
        restart: :permanent
      )
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Excerpt.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
