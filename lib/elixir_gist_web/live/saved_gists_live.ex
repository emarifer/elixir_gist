defmodule ElixirGistWeb.SavedGistsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGistWeb.PersonalGistsHeaderComponent

  def mount(_params, _session, socket) do
    {:ok, socket |> assign(:page_title, "Saved gists")}
  end

  def handle_params(_params, uri, socket) do
    %{path: path} = URI.parse(uri)

    {:noreply, socket |> assign(:path, path)}
  end
end
