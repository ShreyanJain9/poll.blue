defmodule PollBlue.Repo do
  use Ecto.Repo,
    otp_app: :poll_blue,
    adapter: Ecto.Adapters.Postgres
end
