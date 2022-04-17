defmodule Weedx.Operation do
  @moduledoc """
  A helper module to construct requests to feed to `Weedx` functions.
  """

  alias Weedx.Filer.ListEntriesRequest

  @type list_entries_opts :: [
          {:limit, non_neg_integer()}
          | {:last_file_name, String.t()}
        ]

  @doc """
  Create a list entries request for a directory. The result are ordered by filename.

  ## Options
    * `limit` - The max number of items to return. A default value is `nil`
      will return all the entries in a folder.

    * `last_file_name` - Used for setting an offset for pagination, the last file name processed,
      if it's set, the new request will return all the files after this one.
  """
  @spec list_entries(String.t(), list_entries_opts()) :: ListEntriesRequest.t()
  def list_entries(directory, opts \\ []) do
    ListEntriesRequest.new!(%{
      directory: directory,
      limit: Keyword.get(opts, :limit),
      startFromFileName: Keyword.get(opts, :last_file_name),
      inclusiveStartFrom: false
    })
  end
end
