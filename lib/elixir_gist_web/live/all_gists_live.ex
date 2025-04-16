defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  alias ElixirGistWeb.GistPreviewComponent

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
