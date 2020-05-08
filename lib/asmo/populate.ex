defmodule Asmo.Populate do
  def run(id) do
    legacy = Application.fetch_env!(:asmo, :legacy)
    modern = Application.fetch_env!(:asmo, :modern)
    {bucket, pattern} = Enum.random([legacy, modern])
    key = String.replace(pattern, "\d+", to_string(id))

    {:ok, path} = temp_file(id)

    Asmo.S3.upload(bucket, key, path)
    Asmo.DB.insert_multi([{id, key}])
  end

  defp temp_file(id) do
    {:ok, _fd, path} = Temp.open(%{prefix: "asmo-temp", suffix: ".png"})

    File.write!(path, "PNG_IMAGE #{id}")

    {:ok, path}
  end
end
