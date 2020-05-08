defmodule Mix.Tasks.ResetTable do
  use Mix.Task

  @shortdoc "Print distribution of assets between legacy and modern buckets"
  def run(_) do
    {:ok, _apps} = Application.ensure_all_started(:asmo)

    Asmo.DB.drop_table()
    Asmo.DB.create_table()
  end
end
