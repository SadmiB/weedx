defmodule Weedx do
  @moduledoc """
  A client library for [seaweedfs](https://github.com/chrislusf/seaweedfs) filer.
  """

  use Application

  alias Weedx.Filer.{
    Entry,
    ListEntriesRequest,
    SeaweedFiler,
    AtomicRenameEntryRequest,
    AtomicRenameEntryResponse
  }

  alias Weedx.{Config, Connection}

  @spec list_directory(ListEntriesRequest.t(), Keyword.t()) ::
          list(Entry.t()) | {:error, GRPC.RPCError.t()}
  def list_directory(request, config_overrides \\ []) do
    request
    |> stream_directory(config_overrides)
    |> Enum.to_list()
  end

  @spec stream_directory(ListEntriesRequest.t(), Keyword.t()) ::
          list(Entry) | {:error, GRPC.RPCError.t()}
  def stream_directory(request, config_overrides \\ []) do
    conn =
      config_overrides
      |> Config.new()
      |> get_connection()

    case SeaweedFiler.Stub.list_entries(conn, request) do
      {:ok, stream} -> Stream.map(stream, fn {:ok, reply} -> reply.entry end)
      error -> error
    end
  end

  @spec move(AtomicRenameEntryRequest.t(), Keyword.t()) ::
          :ok | {:error, GRPC.RPCError.t()}
  def move(request, config_override \\ []) do
    conn =
      config_override
      |> Config.new()
      |> get_connection()

    case SeaweedFiler.Stub.atomic_rename_entry(conn, request) do
      {:ok, %AtomicRenameEntryResponse{}} -> :ok
      error -> error
    end
  end

  defp get_connection(config) do
    with host <- config[:host],
         port <- config[:grpc_port],
         {:error, :not_found} <- Connection.lookup_connection({host, port}),
         {:ok, connection} <- GRPC.Stub.connect("#{host}:#{port}") do
      Connection.add_connection({host, port}, connection)
      connection
    else
      {:ok, connection} ->
        connection

      {:error, error} ->
        throw("""
        Could not connect to "#{config[:host]}:#{config[:grpc_host]}"

        #{inspect(error)}
        """)
    end
  end

  @doc false
  @impl Application
  def start(_type, _args) do
    children = [
      Weedx.Connection
    ]

    opts = [strategy: :one_for_one, name: Weedx.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
