defmodule ElixirGist.Gists.Gist do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "gists" do
    field :name, :string
    field :description, :string
    field :markup_text, :string
    field :saved_count, :integer, virtual: true
    belongs_to :user, ElixirGist.Accounts.User
    has_many :comments, ElixirGist.Comments.Comment

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(gist, attrs) do
    gist
    |> cast(attrs, [:name, :description, :markup_text, :user_id])
    |> validate_required([:name, :user_id])
  end

  def populate_count(%__MODULE__{saved_count: nil} = gist) do
    saved_count = ElixirGist.Gists.saved_gist_count(gist.id)
    %__MODULE__{gist | saved_count: saved_count}
  end

  def populate_count(%__MODULE__{saved_count: _} = gist), do: gist
end

# REFERENCES:
# https://medium.com/rekkiapp/how-to-use-data-spanning-multiple-data-sources-in-elixir-50f39c87d8fc
