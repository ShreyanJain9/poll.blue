import Config

config :poll_blue,
  http_port: 8080,
  postgres_url: System.get_env("POLL_BLUE_DATABASE_URL")
