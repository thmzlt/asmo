defmodule Mix.Tasks.Move do
  use Mix.Task

  @shortdoc "Move assets from legacy to modern bucket"
  def run(_) do
    {:ok, _apps} = Application.ensure_all_started(:asmo)
    {:ok, _sup_pid} = Asmo.Async.start_pool(Asmo.Move)

    %{rows: rows} = Asmo.DB.query_prefix!("images/", Application.fetch_env!(:asmo, :chunk_size))

    do_run(rows)
  end

  defp do_run([]) do
    :ok
  end

  defp do_run(rows) do
    rows
    |> Enum.map(fn [id, _key] -> Asmo.Async.call(Asmo.Move, id) end)
    |> Enum.map(fn t -> Task.await(t) end)

    %{rows: rows} = Asmo.DB.query_prefix!("images/", Application.fetch_env!(:asmo, :chunk_size))

    do_run(rows)
  end
end
