defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view
  alias ElixirGist.Gists

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  # https://hexdocs.pm/phoenix_live_view/live-navigation.html#handle_params-3
  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_params/3
  def handle_params(_params, _uri, socket) do
    # See note below
    gists = Gists.list_gists()

    socket = assign(socket, gists: gists)

    {:noreply, socket}
  end

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:render/1
  def gist(assigns) do
    ~H"""
    <div class="bg-egDark rounded-lg text-left text-sm text-white flex-col w-fit mx-auto p-4 my-2">
      <div>{@gist.user.email}/{@gist.name}</div>
      <div>{@gist.updated_at}</div>
      <div>{@gist.description}</div>
      <div>{@gist.markup_text}</div>
    </div>
    """
  end
end

# NOTE:
# It contains the preloaded user to whom each gist belongs
# (so you can access the email address of the owner who created it),
# sorted by date and time of update in descending order
# (the most recent is at the top of the list). See:
# https://elixirforum.com/t/how-to-preload-associations-in-ecto-and-then-access-fields-from-those-associations/13316/2
# https://hexdocs.pm/ecto/Ecto.Query.html#order_by/3
