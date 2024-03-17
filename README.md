# PollBlue

This repository, for now, serves as an experiment in refactoring [poll.blue](https://poll.blue).

# How does PollBlue currently work?

Currently, when you visit the https://poll.blue web app, when you create a poll, it does two things.
First, it saves your questions and options in a record in its Postgres database. The structure of this
record is the following:

```elixir
  schema "polls" do

    # This stores the handle of the user who posted the poll.
    # This field can probably be eliminated in favor of post_uri.
    # For many old polls, this field may also not contain the real `handle`
    # of the user, since the TypeScript app, instead of fetching
    # the handle from its authenticated ATP session, was instead
    # simply storing whatever the user entered as their username,
    # which could even be their email.
    field :posted_by

    # The text of the question being asked.
    field :question

    # Each poll is currently associated with a post -
    # when you post from https://poll.blue, a post is created
    # with links to vote on each option, see results, etc.
    # This field stores an at:// uri to that post.
    field :post_uri

    # These are the available options users can vote for.
    field :answers, {:array, :string}

    # [DEPRECATED, WILL BE REMOVED] SQL is fast enough
    # that we can do this dynamically instead.
    field :results, {:array, :integer}

    # [WILL BE DEPRECATED] This is an ID for the poll that is
    # used in poll.blue urls. Personally, I think it should be
    # replaced with using the did and rkey of the post
    # containing the poll, but since older poll posts use this ID
    # in the links, it will probably be supported forever.
    field :visible_id

    # After 24 hours, the @poll.blue Bluesky bot will reply to the
    # post containing a poll with its results. If this has been
    # done, this field should be `true`.
    field :results_posted, :boolean

    # The app used to create the poll - for almost all current
    # polls, this field is set to `poll.blue`.
    field :user_agent

    # The time a poll was posted. This is useful information
    # to have here, but in the future, the canonical source
    # of this will probably be the "createdAt" field in the
    # record the poll comes from.
    field :created_at, :utc_datetime

    # The votes for the poll.
    has_many :votes, PollBlue.Vote

  end
```

As described above, the other thing the app does is create a post that serves as the canonical
ATProto record for the poll. This design, luckily, is flexible enough that we can adapt poll.blue
to be more ATProto-native in the future.
