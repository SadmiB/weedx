defmodule Weedx do
  @moduledoc """
  A client library for [seaweedfs](https://github.com/chrislusf/seaweedfs) filer.
  """

  use Application

  alias Weedx.Filer.{
    ListEntriesRequest,
    SeaweedFiler,
    AtomicRenameEntryRequest,
    AtomicRenameEntryResponse,
    DeleteEntryRequest,
    DeleteEntryResponse
  }

  alias Weedx.{Config, Connection}

  @type operation() :: ListEntriesRequest.t() | AtomicRenameEntryRequest.t()

  @doc """
  Perform a filer request.

  First build a request using `Weedx.Operation`, and then pass it to this
  function to perform it.

  This function takes an optional second parameter of configuration overrides.
  This is useful if you want to have certain configuration changed on a per
  request basis

  ## Examples

      Weedx.Operation.list_entries("/") |> Weedx.request()

      Weedx.Operation.list_entries("/") |> Weedx.request(host: "my-new-filer.com")
  """
  @spec request(operation(), Keyword.t()) :: term()
  def request(request, config_overrides \\ []) do
    config_overrides
    |> Config.new()
    |> get_connection()
    |> do_request(request)
  end

  @doc """
  Return a stream for the filer resource.

  ## Examples

      Weedx.Operation.list_entries("/") |> Weedx.stream()
  """
  @spec stream(operation(), Keyword.t()) :: term()
  def stream(request, config_overrides \\ []) do
    config_overrides
    |> Config.new()
    |> get_connection()
    |> do_stream(request)
  end

  defp do_request(connection, %ListEntriesRequest{} = request) do
    connection
    |> do_stream(request)
    |> Enum.to_list()
  end

  defp do_request(connection, %AtomicRenameEntryRequest{} = request) do
    connection
    |> SeaweedFiler.Stub.atomic_rename_entry(request)
    |> case do
      {:ok, %AtomicRenameEntryResponse{}} -> :ok
      error -> error
    end
  end

  defp do_request(connection, %DeleteEntryRequest{} = request) do
    connection
    |> SeaweedFiler.Stub.delete_entry(request)
    |> case do
      {:ok, %DeleteEntryResponse{}} -> :ok
      error -> error
    end
  end

  defp do_request(_connection, request) do
    throw("""
    request not implemented for request:

    #{inspect(request)}
    """)
  end

  defp do_stream(connection, %ListEntriesRequest{} = request) do
    connection
    |> SeaweedFiler.Stub.list_entries(request)
    |> case do
      {:ok, stream} -> Stream.map(stream, fn {:ok, reply} -> reply.entry end)
      error -> error
    end
  end

  defp do_stream(_connection, request) do
    throw("""
    Stream operation is not supported for request:

    #{inspect(request)}
    """)
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
