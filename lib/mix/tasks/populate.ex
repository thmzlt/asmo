defmodule Mix.Tasks.Populate do
  use Mix.Task

  @pool :populate_pool

  @shortdoc "Create and distribute assets between the buckets"
  def run([]) do
    run(["1000", "1"])
  end

  def run([count]) do
    run([count, "1"])
  end

  def run([count, offset]) do
    {:ok, _apps} = Application.ensure_all_started(:asmo)

    {:ok, _sup_pid} =
      Supervisor.start_link(
        [:poolboy.child_spec(@pool, pool_options())],
        strategy: :one_for_one,
        name: Asmo.Populate.Supervisor
      )

    count = String.to_integer(count)
    offset = String.to_integer(offset)
    range = offset..(offset + count)

    range
    |> Enum.chunk_every(Application.fetch_env!(:asmo, :chunk_size))
    |> Enum.each(fn chunk ->
      chunk
      |> Enum.map(fn i -> spawn_worker(i) end)
      |> Enum.map(fn t -> Task.await(t) end)
    end)
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
      worker_module: Asmo.Populate,
      size: Application.fetch_env!(:asmo, :process_pool_size),
      max_overflow: 0
    ]
  end
end
