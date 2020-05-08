defmodule Asmo.DB do
  @moduledoc false

  @name :myxql

  @spec create_table!() :: %MyXQL.Result{}

  def create_table! do
    {:ok, query} =
      MyXQL.prepare(:myxql, "", """
        CREATE TABLE `assets` (
            `id` int(11) NOT NULL,
            `key` varchar(255) NOT NULL,
            PRIMARY KEY (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin
      """)

    MyXQL.execute!(@name, query, [])
  end

  @spec drop_table!() :: %MyXQL.Result{}

  def drop_table! do
    {:ok, query} = MyXQL.prepare(@name, "", "DROP TABLE `assets` ")

    MyXQL.execute!(@name, query, [])
  end

  @spec insert_multi!([{integer(), String.t()}]) :: %MyXQL.Result{}

  def insert_multi!(values) do
    value_string =
      values
      |> Enum.map(fn {id, key} -> "(#{id}, '#{key}') " end)
      |> Enum.join(",")

    {:ok, query} =
      MyXQL.prepare(@name, "", "INSERT INTO `assets` (`id`, `key`) values #{value_string}")

    MyXQL.execute!(@name, query, [])
  end

  @spec query_prefix!(String.t(), integer()) :: %MyXQL.Result{}

  def query_prefix!(key_prefix, limit \\ -1) do
    {:ok, query} =
      MyXQL.prepare(@name, "", "SELECT `id`,`key` FROM assets WHERE `key` LIKE ? LIMIT ?")

    MyXQL.execute!(@name, query, ["#{key_prefix}%", limit])
  end

  @spec update!(String.t(), String.t()) :: %MyXQL.Result{}

  def update!(id, key) do
    {:ok, query} = MyXQL.prepare(@name, "", "UPDATE assets SET `key` = ? WHERE `id` = ?")

    MyXQL.execute!(@name, query, [key, id])
  end
end
