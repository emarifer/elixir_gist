defmodule ElixirGistWeb.AllGistsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Gists
  alias ElixirGistWeb.GistPreviewComponent

  # https://github.com/adrianlimcy/phoenix_pagination
  # https://medium.com/@michaelmunavu83/streamlining-pagination-in-phoenix-live-view-with-scrivener-5ceb6e6fe642
  # https://hexdocs.pm/scrivener_ecto/readme.html#usage
  def mount(_params, _session, socket) do
    form = to_form(%{"search" => ""})

    {:ok,
     socket
     |> assign(form: form)
     |> assign(:page_title, "All gists")}
  end

  def handle_event("search", params, socket) do
    case params do
      %{"search" => ""} ->
        {:noreply, socket}

      %{"search" => search} ->
        {:noreply, push_patch(socket, to: ~p"/all?#{[search: search]}")}
    end
  end

  def handle_event("reset-search", _params, socket) do
    {:noreply, push_patch(socket, to: ~p"/all")}
  end

  # https://hexdocs.pm/phoenix_live_view/live-navigation.html#handle_params-3
  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:handle_params/3
  def handle_params(params, _uri, socket) do
    # See note below
    # gists = Gists.list_gists()

    search =
      case params do
        %{"search" => search} -> search
        _ -> ""
      end

    # Avoid 2 requests to the database when the component is mounted.
    # See below for details on whether or not to double-request the DB.
    if connected?(socket) do
      %Scrivener.Page{
        entries: gists,
        total_pages: total_pages,
        page_number: page_number,
        total_entries: total_entries
      } = Gists.paginate_gists(params)

      {:noreply,
       socket
       |> assign(:gists, gists)
       |> assign(:search, search)
       |> assign(:total_pages, total_pages)
       |> assign(:page_number, page_number)
       |> assign(:total_entries, total_entries)}
    else
      {:noreply,
       socket
       |> assign(:gists, nil)
       |> assign(:search, search)}
    end
  end
end

# REFERENCES:
# Possible ways to perform pagination in Phoenix ==>
# https://www.google.com/search?q=phoenix+pagination&oq=phoenix+pagi&gs_lcrp=EgZjaHJvbWUqCQgBEAAYExiABDIGCAAQRRg5MgkIARAAGBMYgAQyCggCEAAYExgWGB4yCggDEAAYExgWGB4yCggEEAAYExgWGB4yCggFEAAYExgWGB4yCggGEAAYExgWGB4yCggHEAAYExgWGB4yCggIEAAYExgWGB4yCggJEAAYExgWGB7SAQkxMDYyMmowajeoAgiwAgE&sourceid=chrome&ie=UTF-8
# https://fullstackphoenix.com/tutorials/pagination-with-phoenix-liveview

# LIVEVIEW AND DATABASE QUERIES, DOES THIS RUN ONCE OR TWICE?:
# https://elixirforum.com/t/liveview-calls-mount-two-times/30519/4
# https://elixirforum.com/t/liveview-and-database-queries-does-this-run-once-or-twice/55050/8
# https://elixirforum.com/t/mount-vs-handle-params-on-the-liveview-life-cycle/31920/3
# https://kobrakai.de/kolumne/liveview-double-mount
# https://elixirforum.com/t/how-to-pass-data-from-the-assigns-in-the-first-mount-call-to-the-second-mount-in-liveview/62419

# NOTE:
# It contains the preloaded user to whom each gist belongs
# (so you can access the email address of the owner who created it),
# sorted by date and time of update in descending order
# (the most recent is at the top of the list). See:
# https://elixirforum.com/t/how-to-preload-associations-in-ecto-and-then-access-fields-from-those-associations/13316/2
# https://hexdocs.pm/ecto/Ecto.Query.html#order_by/3
