defmodule Asmo.S3 do
  @moduledoc false

  @spec copy!(String.t(), String.t(), String.t(), String.t()) :: %{status_code: integer()}

  def copy!(dest_bucket, dest_key, src_bucket, src_key) do
    request = ExAws.S3.put_object_copy(dest_bucket, dest_key, src_bucket, src_key)

    ExAws.request!(request)
  end

  @spec delete!(String.t(), String.t()) :: %{status_code: integer()}

  def delete!(bucket, key) do
    request = ExAws.S3.delete_object(bucket, key)

    ExAws.request!(request)
  end

  @spec upload!(String.t(), String.t(), String.t()) :: %{status_code: integer()}

  def upload!(bucket, key, path) do
    data = File.read!(path)
    request = ExAws.S3.put_object(bucket, key, data, acl: :public_read)

    ExAws.request!(request)
  end
end
