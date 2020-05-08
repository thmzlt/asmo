defmodule Mix.Tasks.Move do
  use Mix.Task

  @pool :move_pool

  @shortdoc "Move assets from legacy to modern bucket"
  def run(_) do
    {:ok, _apps} = Application.ensure_all_started(:asmo)

    {:ok, _sup_pid} =
      Supervisor.start_link(
        [:poolboy.child_spec(@pool, pool_options())],
        strategy: :one_for_one,
        name: Asmo.Move.Supervisor
      )

    %{rows: rows} = Asmo.DB.query_prefix!("images/", Application.fetch_env!(:asmo, :chunk_size))

    do_run(rows)
  end

  defp do_run([]) do
    :ok
  end

  defp do_run(rows) do
    rows
    |> Enum.map(fn [id, _key] -> spawn_worker(id) end)
    |> Enum.map(fn t -> Task.await(t) end)

    %{rows: rows} = Asmo.DB.query_prefix!("images/", Application.fetch_env!(:asmo, :chunk_size))

    do_run(rows)
  end

  defp spawn_worker(id) do
    Task.async(fn ->
      :poolboy.transaction(
        @pool,
        fn pid ->
          GenServer.call(pid, {:run, id})
        end,
        Application.fetch_env!(:asmo, :process_timeout)
      )
    end)
  end

  defp pool_options do
    [
      name: {:local, @pool},
      worker_module: Asmo.Move,
      size: Application.fetch_env!(:asmo, :process_pool_size),
      max_overflow: 0
    ]
  end
end
