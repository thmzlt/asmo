defmodule Asmo.Async do
  @spec start_pool(module()) :: {:ok, pid()}

  def start_pool(worker_module) do
    Supervisor.start_link(
      [:poolboy.child_spec(worker_module, pool_options(worker_module))],
      strategy: :one_for_one,
      name: Asmo.Populate.Supervisor
    )
  end

  @spec pool_options(module()) :: list()

  def pool_options(worker_module) do
    [
      name: {:local, worker_module},
      worker_module: worker_module,
      size: Application.fetch_env!(:asmo, :process_pool_size),
      max_overflow: 0
    ]
  end

  @spec call(module(), term()) :: Task.t()

  def call(worker_module, args) do
    Task.async(fn ->
      :poolboy.transaction(
        worker_module,
        fn pid ->
          GenServer.call(pid, {:run, args})
        end,
        Application.fetch_env!(:asmo, :process_timeout)
      )
    end)
  end
end
