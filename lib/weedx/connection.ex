defmodule Weedx.Connection do
  @moduledoc """
  A GenServer responsible for saving and looking up grpc connections to remote servers.

  The GenServer is a wrapper around an `ets` table.

  Each different {host, port} combination will create a new connection and saved in an `ets` table
  with the key as `{host, port}` and the value as the connection
  """

  use GenServer

  @type key :: {String.t(), non_neg_integer()}
  @type value :: GRPC.Channel.t()

  def start_link(_opts) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  @spec add_connection(key(), value()) :: boolean()
  def add_connection({host, port}, connection) do
    :ets.insert(:weedx_connections, {{host, port}, connection})
  end

  @spec lookup_connection(key()) :: {:error, :not_found} | {:ok, value()}
  def lookup_connection({host, port}) do
    case :ets.lookup(:weedx_connections, {host, port}) do
      [{_key, connection}] -> {:ok, connection}
      _ -> {:error, :not_found}
    end
  end

  @spec delete_connection(key()) :: boolean()
  def delete_connection({host, port}) do
    :ets.delete(:weedx_connections, {host, port})
  end

  def init(_args) do
    :ets.new(:weedx_connections, [:set, :public, :named_table])
    {:ok, nil}
  end
end
