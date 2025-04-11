defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  alias ElixirGistWeb.Utilities.DateFormat

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
    <div class="justify-center px-28 w-full mb-20">
      <div class="flex justify-between mb-4">
        <div class="flex items-center">
          <img
            src="/images/user-image.svg"
            alt="Profile Image"
            class="round-image-padding w-8 h-8 mb-6"
          />
          <div class="flex flex-col ml-4">
            <div class="font-bold text-base text-egLavender-dark">
              {@gist.user.email}<span class="text-white"> / </span>{@gist.name}
            </div>
            <div class="font-bold text-lg text-white">
              {DateFormat.get_relative_time(@gist.updated_at)}
            </div>
            <p class="text-sm text-white">
              {@gist.description}
            </p>
          </div>
        </div>
      </div>
      <div class="text-xs text-white my-2">{@gist.markup_text}</div>
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
