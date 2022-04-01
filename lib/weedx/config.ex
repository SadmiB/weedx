defmodule Weedx.Config do
  @moduledoc """
  Generates the configuration of `Weedx`.

  it starts with the defaults, then merge the config from weedx config root,
  and then finally merge any config specified in operations.
  """

  @defaults [host: "localhost", grpc_port: 18_888]
  @keys Keyword.keys(@defaults)

  @type t :: %{} | Keyword.t()

  @spec new(Keyword.t()) :: t()
  def new(config_overrides) do
    root_config = Keyword.take(Application.get_all_env(:weedx), @keys)
    config_overrides = Keyword.take(config_overrides, @keys)

    @defaults
    |> Keyword.merge(root_config)
    |> Keyword.merge(config_overrides)
    |> validate()
  end

  defp validate(config) do
    port = Keyword.get(config, :grpc_port)

    if not is_integer(port) and port not in [1..65_535] do
      throw("""
      Invalid config value 'grpc_port'. Expected an integer between 1 and 65535.
      Got #{inspect(port)}
      """)
    end

    config
  end
end
