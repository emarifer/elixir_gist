defmodule ElixirGistWeb.GistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGistWeb.{GistFormComponent, Utilities.DateFormat}
  alias ElixirGist.Gists

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)

    gist =
      Map.put(gist, :relative, DateFormat.get_relative_time(gist.updated_at))

    {:ok, assign(socket, gist: gist, page_title: "Show gist")}
  end

  def handle_event("delete", %{"id" => id}, socket) do
    case Gists.delete_gist(socket.assigns.current_user, id) do
      {:ok, _gist} ->
        socket = put_flash(socket, :info, "Gist Successfully Deleted")
        {:noreply, redirect(socket, to: ~p"/create")}

      {:error, message, gist} ->
        socket = put_flash(socket, :error, message)
        {:noreply, redirect(socket, to: ~p"/gist?#{[id: gist]}")}
    end
  end
end
