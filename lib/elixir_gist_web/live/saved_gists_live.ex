defmodule ElixirGistWeb.SavedGistsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGistWeb.{
    GistPreviewComponent,
    PersonalGistsHeaderComponent
  }

  alias ElixirGist.Gists

  def mount(_params, _session, socket) do
    saved_gists = Gists.list_saved_gists(socket.assigns.current_user)

    {:ok,
     socket
     |> assign(:saved_gists, saved_gists)
     |> assign(:page_title, "Saved gists")}
  end

  def handle_params(_params, uri, socket) do
    %{path: path} = URI.parse(uri)

    {:noreply, socket |> assign(:path, path)}
  end
end
