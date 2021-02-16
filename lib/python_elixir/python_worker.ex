defmodule PythonElixir.PythonWorker do
  use GenServer

  require Logger

  @timeout 10_000

  def start_link() do
    GenServer.start_link(__MODULE__, nil)
  end

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def message(pid, my_string) do
    GenServer.call(pid, {:hello, my_string})
  end

  def call(my_string) do
    Task.async(fn ->
      :poolboy.transaction(
        :python_worker,
        fn pid ->
          GenServer.call(pid, {:hello, my_string})
        end,
        @timeout
      )
    end)
    |> Task.await(@timeout)
  end

  #############
  # Callbacks #
  #############

  @impl true
  def init(_) do
    path =
      [:code.priv_dir(:python_elixir), "python"]
      |> Path.join()

    with {:ok, pid} <- :python.start([{:python_path, to_charlist(path)}, {:python, 'python3'}]) do
      Logger.info("[#{__MODULE__}] Started python worker")
      {:ok, pid}
    end
  end

  @impl true
  def handle_call({:hello, my_string}, _from, pid) do
    result = :python.call(pid, :python_message, :hello, [my_string])
    Logger.info("[#{__MODULE__}] Handled call")
    {:reply, {:ok, result}, pid}
  end
end
