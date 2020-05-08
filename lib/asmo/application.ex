defmodule Asmo.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      {MyXQL, db_options()}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Asmo.Supervisor)
  end

  defp db_options() do
    db =
      "terraform.tfstate"
      |> File.read!()
      |> Jason.decode!()
      |> Map.get("resources")
      |> Enum.find(fn n -> n["name"] == "database" end)
      |> Map.get("instances")
      |> Enum.at(0)
      |> Map.get("attributes")

    [
      hostname: db["address"],
      database: db["name"],
      username: db["username"],
      password: db["password"],
      name: :myxql,
      show_sensitive_data_on_connection_error: true
    ]
  end
end
