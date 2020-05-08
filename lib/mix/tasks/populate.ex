defmodule Mix.Tasks.Populate do
  use Mix.Task

  @shortdoc "Create and distribute assets between the buckets"
  def run([]) do
    run(["1000", "1"])
  end

  def run([count]) do
    run([count, "1"])
  end

  def run([count, offset]) do
    count = String.to_integer(count)
    offset = String.to_integer(offset)
    range = offset..(offset + count - 1)

    {:ok, _apps} = Application.ensure_all_started(:asmo)
    {:ok, _sup_pid} = Asmo.Async.start_pool(Asmo.Populate)

    range
    |> Enum.chunk_every(Application.fetch_env!(:asmo, :chunk_size))
    |> Enum.each(fn chunk ->
      chunk
      |> Enum.map(fn i -> Asmo.Async.call(Asmo.Populate, i) end)
      |> Enum.map(fn t -> Task.await(t) end)
    end)
  end
end
