# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :backcaster,
  ecto_repos: [Backcaster.Repo]

# Configures the endpoint
config :backcaster, BackcasterWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "vOJaM+oYucXiTxP/CUg3HwTMmnS32ya9gpqrOhKv8YPf3eR2yKOYz+bzR0VCIeDq",
  render_errors: [view: BackcasterWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Backcaster.PubSub,
  live_view: [signing_salt: "5qXHbBxG"]

# Configure esbuild (the version is required)
config :esbuild,
       version: "0.12.18",
       default: [
         args: ~w(js/app.js --bundle --target=es2016 --outdir=../priv/static/assets),
         cd: Path.expand("../assets", __DIR__),
         env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
       ]

# Configures the mailer.
#
# By default it uses the "Local" adapter which stores the emails
# locally. You can see the emails in your browser, at "/dev/mailbox".
#
# For production it's recommended to configure a different adapter
# at the `config/runtime.exs`.
config :backcaster, Backcaster.Mailer, adapter: Swoosh.Adapters.Local

# Swoosh API client is needed for adapters other than SMTP.
config :swoosh, :api_client, false

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason


config :waffle,
       storage: Waffle.Storage.S3,
       bucket: {:system, "AWS_BUCKET_NAME"},           # or {:system, "AWS_S3_BUCKET"}
       asset_host: {:system, "ASSET_HOST"}

config :ex_aws,
       json_codec: Jason,
       access_key_id: {:system, "AWS_ACCESS_KEY_ID"},
       secret_access_key: {:system, "AWS_SECRET_ACCESS_KEY"},
       region: {:system, "AWS_REGION"}


# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
