defmodule ElixirGistWeb.GistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGistWeb.GistFormComponent
  alias ElixirGist.Gists

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)

    {:ok, relative_time} =
      Timex.format(gist.updated_at, "{relative}", :relative)

    gist = Map.put(gist, :relative, relative_time)

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
