defmodule CryptoBot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Starts a worker by calling: CryptoBot.Worker.start_link(arg)
      # {CryptoBot.Worker, arg}
      ExGram,
      {CryptoBot.Bot, [method: :polling, token: "5295043872:AAGvrOttEmabnI31obspILWGRirh1snigbs"]}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: CryptoBot.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
