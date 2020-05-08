defmodule Asmo.S3 do
  @moduledoc false

  @spec copy(String.t(), String.t(), String.t(), String.t()) :: {:ok, term()}

  def copy(dest_bucket, dest_key, src_bucket, src_key) do
    request = ExAws.S3.put_object_copy(dest_bucket, dest_key, src_bucket, src_key)

    {:ok, _res} = ExAws.request!(request)
  end

  @spec delete(String.t(), String.t()) :: {:ok, term()}

  def delete(bucket, key) do
    request = ExAws.S3.delete_object(bucket, key)

    {:ok, _res} = ExAws.request!(request)
  end

  @spec upload(String.t(), String.t(), String.t()) :: {:ok, term()}

  def upload(bucket, key, path) do
    data = File.read!(path)
    request = ExAws.S3.put_object(bucket, key, data, acl: :public_read)

    {:ok, _res} = ExAws.request(request)
  end
end
