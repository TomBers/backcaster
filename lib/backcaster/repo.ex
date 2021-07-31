defmodule Backcaster.Repo do
  use Ecto.Repo,
    otp_app: :backcaster,
    adapter: Ecto.Adapters.Postgres
end
