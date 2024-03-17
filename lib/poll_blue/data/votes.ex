defmodule PollBlue.Vote do
  use Ecto.Schema

  schema "votes" do
    belongs_to :poll, PollBlue.Poll
    field :did
    field :ip, :integer
    field :vote, :integer
  end
end
