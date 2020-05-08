defmodule Asmo.Move do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil)
  end

  def init(_) do
    {:ok, nil}
  end

  def handle_call({:run, id}, _from, state) do
    {l_bucket, l_pattern} = Application.fetch_env!(:asmo, :legacy)
    {m_bucket, m_pattern} = Application.fetch_env!(:asmo, :modern)
    l_key = String.replace(l_pattern, "\d+", to_string(id))
    m_key = String.replace(m_pattern, "\d+", to_string(id))

    Asmo.S3.copy!(m_bucket, m_key, l_bucket, l_key)
    Asmo.DB.update!(id, m_key)
    Asmo.S3.delete!(l_bucket, l_key)

    {:reply, :ok, state}
  end
end
