defmodule ElixirGist.Gists do
  @moduledoc """
  The Gists context.
  """

  import Ecto.Query, warn: false

  alias ElixirGist.Accounts.User
  alias ElixirGist.Repo

  alias ElixirGist.Gists.Gist
  alias ElixirGist.Gists.SavedGist

  # https://elixirforum.com/t/how-to-preload-associations-in-ecto-and-then-access-fields-from-those-associations/13316/2
  # https://hexdocs.pm/ecto/Ecto.Query.html#order_by/3
  @doc """
  Returns the list of gists.

  ## Examples

      iex> list_gists()
      [%Gist{}, ...]

  """
  def list_gists do
    Gist
    |> order_by(desc: :updated_at)
    |> Repo.all()
    |> Repo.preload([:user])
  end

  # https://github.com/adrianlimcy/phoenix_pagination
  # https://medium.com/@michaelmunavu83/streamlining-pagination-in-phoenix-live-view-with-scrivener-5ceb6e6fe642
  # https://hexdocs.pm/scrivener_ecto/readme.html#usage
  def paginate_gists(params) do
    result =
      case params do
        %{"search" => search_term} ->
          Gist
          |> where(
            [g],
            ilike(g.description, ^"%#{search_term}%") or ilike(g.name, ^"%#{search_term}%")
          )
          |> order_by(desc: :updated_at)
          |> preload(:user)
          |> Repo.paginate(params)

        _ ->
          Gist
          |> order_by(desc: :updated_at)
          |> preload(:user)
          |> Repo.paginate(params)
      end

    %Scrivener.Page{entries: gists} = result

    %{result | entries: gists |> Enum.map(&Gist.populate_count/1)}
  end

  # https://hexdocs.pm/ecto/Ecto.Query.html#where/3
  def personal_gists(user, params) do
    result =
      Gist
      |> where([g], g.user_id == ^user.id)
      |> order_by(desc: :updated_at)
      |> preload(:user)
      |> Repo.paginate(params)

    %Scrivener.Page{entries: gists} = result

    %{result | entries: gists |> Enum.map(&Gist.populate_count/1)}
  end

  @doc """
  Gets a single gist.

  Raises `Ecto.NoResultsError` if the Gist does not exist.

  ## Examples

      iex> get_gist!(123)
      %Gist{}

      iex> get_gist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gist!(id) do
    Gist
    |> Repo.get!(id)
    |> Repo.preload([:user, [comments: :user]])
  end

  # ↑↑↑↑↑ https://elixirforum.com/t/ecto-query-preloading-nested-associations/51582/2

  @doc """
  Creates a gist.

  ## Examples

      iex> create_gist(%{field: value})
      {:ok, %Gist{}}

      iex> create_gist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gist(user, attrs \\ %{}) do
    user
    |> Ecto.build_assoc(:gists)
    |> Gist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gist.

  ## Examples

      iex> update_gist(user, %{field: new_value})
      {:ok, %Gist{}}

      iex> update_gist(gist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gist(%User{} = user, attrs) do
    gist = Repo.get!(Gist, attrs["id"])

    if user.id == gist.user_id do
      gist
      |> Gist.changeset(attrs)
      |> Repo.update()
    else
      {:error, :unauthorized, gist}
    end
  end

  @doc """
  Delete a gist by verifying that the gist belongs to
  the user requesting the deletion action.

  ## Examples

      iex> delete_gist(user, gist_id)
      {:ok, %Gist{}}

      iex> delete_gist(user, gist_id)
      {:error, :unauthorized, %Gist{}}

  """
  def delete_gist(%User{} = user, gist_id) do
    gist = Repo.get!(Gist, gist_id)

    if user.id == gist.user_id do
      Repo.delete(gist)

      {:ok, gist}
    else
      {:error, :unauthorized, gist}
    end
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gist changes.

  ## Examples

      iex> change_gist(gist)
      %Ecto.Changeset{data: %Gist{}}

  """
  def change_gist(%Gist{} = gist, attrs \\ %{}) do
    Gist.changeset(gist, attrs)
  end

  @doc """
  Returns the list of saved_gists.

  ## Examples

      iex> list_saved_gists()
      [%SavedGist{}, ...]

  """
  def list_saved_gists(user) do
    # https://elixirforum.com/t/ecto-query-order-for-preload/16714
    # https://tech.appunite.com/blog/ecto-query-preload-vs-ecto-repo-preload?redirected=true
    # https://medium.com/rekkiapp/how-to-use-data-spanning-multiple-data-sources-in-elixir-50f39c87d8fc

    result =
      SavedGist
      |> where([sg], sg.user_id == ^user.id)
      |> Repo.all()
      |> Repo.preload([:user, gist: :user])
      |> Enum.sort(&(&1.gist.updated_at > &2.gist.updated_at))

    for sg <- result do
      %SavedGist{gist: gist} = sg
      %{sg | gist: gist |> Gist.populate_count()}
    end

    # ↑↑↑↑↑ # See references for this below # ↑↑↑↑↑ #
    # https://github.com/elixir-ecto/ecto/issues/2550#issuecomment-389666260
  end

  #  ↑↑↑↑↑  https://github.com/elixir-ecto/ecto/issues/2550
  # https://github.com/elixir-ecto/ecto/issues/2550#issuecomment-389666260
  # https://stackoverflow.com/questions/51758710/how-can-i-sort-list-of-map-by-map-value-in-elixir

  # https://elixirforum.com/t/repo-aggregate-queryable-count-id-vs-select-count-element-id/46449
  # https://stackoverflow.com/questions/36683238/count-the-number-of-entries-in-an-ecto-repository
  # ↓↓↓↓↓ # See references for this above # ↓↓↓↓↓ #

  def saved_gist_count(gist_id) do
    SavedGist
    |> where([sg], sg.gist_id == ^gist_id)
    |> Repo.aggregate(:count)
  end

  def user_has_gist_saved?(user_id, gist_id) do
    SavedGist
    |> where([sg], sg.gist_id == ^gist_id and sg.user_id == ^user_id)
    |> Repo.aggregate(:count) >= 1
  end

  @doc """
  Gets a single saved_gist.

  Raises `Ecto.NoResultsError` if the Saved gist does not exist.

  ## Examples

      iex> get_saved_gist!(123)
      %SavedGist{}

      iex> get_saved_gist!(456)
      ** (Ecto.NoResultsError)

  """
  def get_saved_gist!(id), do: Repo.get!(SavedGist, id)

  @doc """
  Creates a saved_gist.

  ## Examples

      iex> create_saved_gist(%{field: value})
      {:ok, %SavedGist{}}

      iex> create_saved_gist(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_saved_gist(attrs \\ %{}) do
    %SavedGist{}
    |> SavedGist.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a saved_gist.

  ## Examples

      iex> update_saved_gist(saved_gist, %{field: new_value})
      {:ok, %SavedGist{}}

      iex> update_saved_gist(saved_gist, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_saved_gist(%SavedGist{} = saved_gist, attrs) do
    saved_gist
    |> SavedGist.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a saved_gist.

  ## Examples

      iex> delete_saved_gist(saved_gist)
      {:ok, %SavedGist{}}

      iex> delete_saved_gist(saved_gist)
      {:error, %Ecto.Changeset{}}

  """

  # def delete_saved_gist(user_id, gist_id) do
  #   Repo.delete(saved_gist)
  # end
  # https://elixirforum.com/t/ecto-delete-a-record-without-selecting-first/20024/2
  def delete_saved_gist(user_id, gist_id) do
    from(sg in SavedGist, where: sg.gist_id == ^gist_id and sg.user_id == ^user_id)
    |> Repo.delete_all()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking saved_gist changes.

  ## Examples

      iex> change_saved_gist(saved_gist)
      %Ecto.Changeset{data: %SavedGist{}}

  """
  def change_saved_gist(%SavedGist{} = saved_gist, attrs \\ %{}) do
    SavedGist.changeset(saved_gist, attrs)
  end
end
