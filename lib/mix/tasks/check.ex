defmodule Mix.Tasks.Check do
  use Mix.Task

  @shortdoc "Print distribution of assets between legacy and modern buckets"
  def run(_) do
    {:ok, _apps} = Application.ensure_all_started(:asmo)

    %{num_rows: legacy} = "images/" |> Asmo.DB.query_prefix!()
    %{num_rows: modern} = "avatar/" |> Asmo.DB.query_prefix!()

    IO.puts("Legacy: #{legacy}")
    IO.puts("Modern: #{modern}")
  end
end
