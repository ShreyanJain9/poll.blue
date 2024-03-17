defmodule PollBlue do
end

defmodule PollBlue.Application do
  use Application

  def start(_type, _args) do
    children = [
      PollBlue.Repo,
      {Plug.Cowboy,
       scheme: :http,
       plug: PollBlue.Router,
       options: [port: Application.get_env(:poll_blue, :http_port)]}
    ]

    opts = [strategy: :one_for_one, name: PollBlue.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
