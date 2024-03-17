defmodule PollBlue.Router do
  use Plug.Router
  plug(:match)
  plug(:dispatch)
  import Ecto.Query

  get "/p/:poll_id" do
    poll = (PollBlue.Poll.by_id(poll_id)
    |> PollBlue.Poll.results
    |> Jason.encode!)
    send_resp(conn, 200, poll)
  end

  get "/favicon.ico" do
    conn
    |> send_resp(200, File.read!("static/favicon.ico"))
  end

  get "/xrpc/blue.poll.post.getResults" do
    conn = Plug.Conn.fetch_query_params(conn)
    %{"did"=> did, "rkey"=> rkey} = conn.params
    poll =
      (from p in PollBlue.Poll, where: p.post_uri == ^"at://#{did}/app.bsky.feed.post/#{rkey}", select: p)
      |> PollBlue.Repo.one()

    if poll do
      send_resp(conn, 200, Jason.encode!(PollBlue.Poll.details(poll)))
    else
      send_resp(conn, 404, "{\"error\": \"Not found\"}")
    end
  end
end
