import Config

config :logger, :console, level: :debug

import_config "#{config_env()}.exs"
