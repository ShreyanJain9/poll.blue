import Config

config :poll_blue,
  http_port: 8080

config :poll_blue, ecto_repos: [PollBlue.Repo]

config :poll_blue, PollBlue.Repo,
  url: System.get_env("POLL_BLUE_DATABASE_URL"),
  ssl_opts: [log_level: :error, verify: :verify_none]
