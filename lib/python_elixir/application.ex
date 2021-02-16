defmodule PythonElixir.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Starts a worker by calling: PythonElixir.Worker.start_link(arg)
      # {PythonElixir.Worker, arg}
      :poolboy.child_spec(:worker, python_poolboy_config())
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: PythonElixir.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp python_poolboy_config do
    [
      {:name, {:local, :python_worker}},
      {:worker_module, PythonElixir.PythonWorker},
      {:size, 5},
      {:max_overflow, 0}
    ]
  end
end
