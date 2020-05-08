defmodule Asmo.Populate do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:run, id}, _from, state) do
    legacy = Application.fetch_env!(:asmo, :legacy)
    modern = Application.fetch_env!(:asmo, :modern)
    {bucket, pattern} = Enum.random([legacy, modern])
    key = String.replace(pattern, "\d+", to_string(id))

    {:ok, path} = temp_file(id)

    Asmo.S3.upload!(bucket, key, path)
    Asmo.DB.insert_multi!([{id, key}])

    {:reply, :ok, state}
  end

  defp temp_file(id) do
    {:ok, _fd, path} = Temp.open(%{prefix: "asmo-temp", suffix: ".png"})

    File.write!(path, "PNG_IMAGE #{id}")

    {:ok, path}
  end
end
