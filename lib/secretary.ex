defmodule Secretary do
  use Application

  @port 4000

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, _args) do
    import Supervisor.Spec, warn: false

    # Define workers and child supervisors to be supervised
    children = [
      # Starts a worker by calling: Secretary.Worker.start_link(arg1, arg2, arg3)
      # worker(Secretary.Worker, [arg1, arg2, arg3]),
      worker(Secretary.Ingestor, []),
      Plug.Adapters.Cowboy.child_spec(:http, Secretary.Router, [port: @port])
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Secretary.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
