defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  alias ElixirGistWeb.Utilities.DateFormat

  # https://github.com/adrianlimcy/phoenix_pagination
  # https://medium.com/@michaelmunavu83/streamlining-pagination-in-phoenix-live-view-with-scrivener-5ceb6e6fe642
  # https://hexdocs.pm/scrivener_ecto/readme.html#usage
  def mount(params, _session, socket) do
    gists = Gists.paginate_gists(params).entries
    total_pages = Gists.paginate_gists(params).total_pages
    page_number = Gists.paginate_gists(params).page_number
    total_entries = Gists.paginate_gists(params).total_entries

    # {:ok, socket |> assign(:page_title, "All gists")}

    {:ok,
     socket
     |> assign(:gists, gists)
     |> assign(:total_pages, total_pages)
     |> assign(:page_number, page_number)
     |> assign(:total_entries, total_entries)
     |> assign(:page_title, "All gists")}
  end

  # https://hexdocs.pm/phoenix_live_view/live-navigation.html#handle_params-3
  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_params/3
  def handle_params(params, _uri, socket) do
    # See note below
    # gists = Gists.list_gists()
    gists = Gists.paginate_gists(params).entries
    total_pages = Gists.paginate_gists(params).total_pages
    page_number = Gists.paginate_gists(params).page_number
    total_entries = Gists.paginate_gists(params).total_entries

    # socket = assign(socket, gists: gists)

    {:noreply,
     socket
     |> assign(:gists, gists)
     |> assign(:total_pages, total_pages)
     |> assign(:page_number, page_number)
     |> assign(:total_entries, total_entries)}
  end

  # https://til.hashrocket.com/posts/d75339a700-named-captures-with-elixir-regular-expressions
  defp get_preview_text(gist) when not is_nil(gist.markup_text) do
    lines = gist.markup_text |> String.split("\n")

    if length(lines) > 10 do
      regex = ~r/(?<bs>^\s+)/
      [line1 | _] = lines
      %{"bs" => bs} = Regex.named_captures(regex, line1)

      (Enum.take(lines, 9) ++ [bs <> "..."]) |> Enum.join("\n")
    else
      gist.markup_text
    end
  end

  defp get_preview_text(_gist), do: ""

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:render/1
  # https://v3.tailwindcss.com/docs/flex-grow
  def gist(assigns) do
    ~H"""
    <div class="justify-center px-28 w-full mb-20 lg:px-52">
      <div class="flex justify-between mb-4">
        <div class="flex items-start">
          <img
            src="/images/user-image.svg"
            alt="Profile Image"
            class="round-image-padding w-8 h-8 flex-none mt-1.5"
          />
          <div class="flex flex-col ml-4">
            <div class="font-bold text-base text-egLavender-dark hover:underline">
              <.link navigate={~p"/gist?#{[id: @gist]}"}>
                {@gist.user.email}<span class="text-white"> / </span>{@gist.name}
              </.link>
            </div>
            <div class="font-bold text-lg text-white">
              {DateFormat.get_relative_time(@gist.updated_at)}
            </div>
            <p class="text-sm text-white">
              {@gist.description}
            </p>
          </div>
        </div>
        <div class="flex items-start gap-3">
          <div class="flex items-center">
            <img src="/images/comment.svg" alt="Comment Count" class="w-5 h-5" />
            <span class="text-white text-sm px-1">0</span>
          </div>
          <div class="flex items-center">
            <img src="/images/BookmarkOutline.svg" alt="Bookmark Count" class="w-5 h-5" />
            <span class="text-white text-sm px-1">0</span>
          </div>
        </div>
      </div>

      <div class="flex w-full">
        <textarea
          class="border border-white font-brand py-2.5 text-xs text-egDark-light bg-egSyntax h-auto w-[54px] text-right overflow-hidden resize-none rounded-bl-md rounded-tl-md border-r-0 focus:outline-none focus:border-white focus:ring-0"
          readonly
        >
    </textarea>
        <div
          id={@gist.id}
          class="bg-egSyntax text-xs border border-white border-l-0 h-auto w-full rounded-br-md rounded-tr-md overflow-x-scroll scroller"
          phx-hook="Highlight"
          data-name={@gist.name}
        >
          <pre><code class="language-elixir">{get_preview_text(@gist)}</code></pre>
        </div>
      </div>
    </div>
    """
  end
end

# REFERENCES:
# Possible ways to perform pagination in Phoenix ==>
# https://www.google.com/search?q=phoenix+pagination&oq=phoenix+pagi&gs_lcrp=EgZjaHJvbWUqCQgBEAAYExiABDIGCAAQRRg5MgkIARAAGBMYgAQyCggCEAAYExgWGB4yCggDEAAYExgWGB4yCggEEAAYExgWGB4yCggFEAAYExgWGB4yCggGEAAYExgWGB4yCggHEAAYExgWGB4yCggIEAAYExgWGB4yCggJEAAYExgWGB7SAQkxMDYyMmowajeoAgiwAgE&sourceid=chrome&ie=UTF-8
# https://fullstackphoenix.com/tutorials/pagination-with-phoenix-liveview

# NOTE:
# It contains the preloaded user to whom each gist belongs
# (so you can access the email address of the owner who created it),
# sorted by date and time of update in descending order
# (the most recent is at the top of the list). See:
# https://elixirforum.com/t/how-to-preload-associations-in-ecto-and-then-access-fields-from-those-associations/13316/2
# https://hexdocs.pm/ecto/Ecto.Query.html#order_by/3
