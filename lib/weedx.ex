defmodule Weedx do
  @moduledoc """
  A client library for [seaweedfs](https://github.com/chrislusf/seaweedfs) filer.
  """

  use Application
  alias Weedx.Config
  alias Weedx.Connection
  alias Weedx.Filer

  @doc false
  @impl Application
  def start(_type, _args) do
    children = [
      Weedx.Connection
    ]

    opts = [strategy: :one_for_one, name: Weedx.Supervisor]
    Supervisor.start_link(children, opts)
  end

  def list_directories(path, config_override \\ []) do
    conn =
      config_override
      |> Config.new()
      |> get_connection()

    request = Filer.ListEntriesRequest.new!(%{directory: path})

    case Filer.SeaweedFiler.Stub.list_entries(conn, request) do
      {:ok, stream} -> Enum.map(stream, fn {:ok, reply} -> reply end)
      error -> error
    end
  end

  defp get_connection(config) do
    host = config[:host]
    port = config[:grpc_port]

    case Connection.lookup_connection({host, port}) do
      {:ok, connection} ->
        connection

      _ ->
        {:ok, channel} = GRPC.Stub.connect(host, port, [])
        Connection.add_connection({host, port}, channel)
        channel
    end
  end
end
