defmodule Slurpee.Repo do
  use Ecto.Repo,
    otp_app: :slurpee,
    adapter: Ecto.Adapters.Postgres
end
