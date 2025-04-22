defmodule ElixirGistWeb.YourGistsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGistWeb.{
    GistPreviewComponent,
    PersonalGistsHeaderComponent
  }

  alias ElixirGist.Gists

  def mount(params, _session, socket) do
    user = socket.assigns.current_user

    %Scrivener.Page{
      entries: gists,
      total_pages: total_pages,
      page_number: page_number,
      total_entries: total_entries
    } = Gists.personal_gists(user, params)

    {:ok,
     socket
     |> assign(:gists, gists)
     |> assign(:total_pages, total_pages)
     |> assign(:page_number, page_number)
     |> assign(:total_entries, total_entries)
     |> assign(:page_title, "Your gists")}
  end

  def handle_params(params, uri, socket) do
    %{path: path} = URI.parse(uri)

    user = socket.assigns.current_user

    %Scrivener.Page{
      entries: gists,
      total_pages: total_pages,
      page_number: page_number,
      total_entries: total_entries
    } = Gists.personal_gists(user, params)

    {:noreply,
     socket
     |> assign(:gists, gists)
     |> assign(:total_pages, total_pages)
     |> assign(:page_number, page_number)
     |> assign(:total_entries, total_entries)
     |> assign(:path, path)}
  end
end
