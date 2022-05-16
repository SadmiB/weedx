defmodule Weedx.Operation do
  @moduledoc """
  A helper module to construct requests to feed to `Weedx` functions.
  """

  alias Weedx.Filer.{ListEntriesRequest, AtomicRenameEntryRequest, DeleteEntryRequest}

  @type list_entries_opts :: [
          {:limit, non_neg_integer()}
          | {:last_file_name, String.t()}
        ]

  @type delete_entry_opts :: [
          {:recursive, boolean()}
          | {:ignore_recursive_error, boolean()}
          | {:from_other_cluster, boolean()}
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

  @spec move(String.t(), String.t()) :: AtomicRenameEntryResponse.t()
  def move(old_path, new_path) do
    old_path = Path.absname(old_path)
    old_dir = Path.dirname(old_path)
    old_name = Path.basename(old_path)
    new_path = Path.absname(new_path)
    new_dir = Path.dirname(new_path)
    new_name = Path.basename(new_path)

    AtomicRenameEntryRequest.new!(%{
      old_directory: old_dir,
      old_name: old_name,
      new_directory: new_dir,
      new_name: new_name
    })
  end

  @spec delete(String.t(), boolean(), delete_entry_opts()) :: DeleteEntryRequest.t()
  def delete(
        path,
        delete_data,
        opts \\ []
      ) do
    path = Path.absname(path)
    dir = Path.dirname(path)
    name = Path.basename(path)

    recursive = Keyword.get(opts, :recursive, false)
    ignore_recursive_error = Keyword.get(opts, :ignore_recursive_error, false)
    from_other_cluster = Keyword.get(opts, :from_other_cluster, false)

    DeleteEntryRequest.new!(%{
      directory: dir,
      name: name,
      is_delete_data: delete_data,
      is_recursive: recursive,
      ignore_recursive_error: ignore_recursive_error,
      is_from_other_cluster: from_other_cluster
    })
  end
end
