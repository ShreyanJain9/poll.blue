defmodule PollBlue.Poll do
  use Ecto.Schema
  import Ecto.Query

  schema "polls" do
    field :posted_by
    field :question
    field :post_uri
    field :answers, {:array, :string}
    field :results, {:array, :integer}
    field :visible_id
    field :results_posted, :boolean
    field :user_agent
    field :created_at, :utc_datetime
    has_many :votes, PollBlue.Vote
  end

  def results(%__MODULE__{} = poll) do
    votes_for(poll)
    |> Enum.map(& &1.vote)
    |> Enum.frequencies()
    |> Enum.map(fn
      {0, interactors} -> {0, interactors}
      {option, count} -> {poll.answers |> Enum.at(option - 1), count}
    end)
    |> Enum.map(fn {option, count} -> %{option: option, count: count} end)
  end

  def votes_for(%__MODULE__{} = poll) do
    poll
    |> PollBlue.Repo.preload(:votes)
    |> Map.get(:votes)
  end

  def by_id(id) do
    __MODULE__
    |> where(visible_id: ^id)
    |> PollBlue.Repo.one() ||
      PollBlue.Repo.get(__MODULE__, id)
    end

  def details(%__MODULE__{} = poll) do
    %{
      question: poll.question,
      votes: results(poll),
      record: extract_uri(poll.post_uri),
      created_at: poll.created_at |> DateTime.to_iso8601()
    }
  end

  def extract_uri("at://" <> rest) do
    [did, lexicon, rkey] = String.split(rest, "/")
    if lexicon in ["app.bsky.feed.post", "blue.poll.poll.poll"] do
      %{
        did: did,
        type: lexicon,
        rkey: rkey
      }
    else
      %{
        error: "Invalid Poll lexicon"
      }
    end
  end
end
