defmodule Weedx do
  @moduledoc """
  A client library for [seaweedfs](https://github.com/chrislusf/seaweedfs) filer.
  """

  use Application

  alias Weedx.Filer.{ListEntriesRequest, ListEntriesResponse, SeaweedFiler}
  alias Weedx.{Config, Connection}

  @spec list_directory(String.t(), Keyword.t()) ::
          list(ListEntriesResponse.t()) | {:error, GRPC.RPCError.t()}
  def list_directory(path, config_override \\ []) do
    conn =
      config_override
      |> Config.new()
      |> get_connection()

    request = ListEntriesRequest.new!(%{directory: path})

    case SeaweedFiler.Stub.list_entries(conn, request) do
      {:ok, stream} -> Enum.map(stream, fn {:ok, reply} -> reply end)
      error -> error
    end
  end

  def rename_file(old_name, new_name, config_override \\ []) do
    conn =
      config_override
      |> Config.new()
      |> get_connection()

    request =
      Filer.AtomicRenameEntryRequest.new!(%{
        old_name: old_name,
        new_name: new_name
      })

    case Filer.SeaweedFiler.Stub.atomic_rename_entry(conn, request) do
      {:ok, %Weedx.Filer.AtomicRenameEntryResponse{}} -> :ok
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
