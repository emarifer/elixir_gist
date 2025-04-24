defmodule ElixirGistWeb.GistLive do
  use ElixirGistWeb, :live_view

  alias ElixirGistWeb.{CommentComponent, GistFormComponent, Utilities.DateFormat}
  alias ElixirGist.{Comments, Gists}

  def mount(%{"id" => id}, _session, socket) do
    gist = Gists.get_gist!(id)
    saved_gist_count = Gists.saved_gist_count(id)
    is_saved = Gists.user_has_gist_saved?(socket.assigns.current_user.id, id)

    gist =
      Map.put(gist, :relative, DateFormat.get_relative_time(gist.updated_at))

    {:ok,
     socket
     |> assign(gist: gist)
     |> assign(count: saved_gist_count)
     |> assign(is_saved: is_saved)
     |> assign(page_title: "Show gist")}
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

  def handle_event("save_gist", %{"user_id" => user_id, "gist_id" => gist_id}, socket) do
    is_saved = Gists.user_has_gist_saved?(user_id, gist_id)

    if !is_saved do
      create_saved_gist(socket, user_id, gist_id)
    else
      delete_saved_gist(socket, user_id, gist_id)
    end
  end

  def handle_event("create_comment", %{"gist_id" => gist_id} = params, socket) do
    case Comments.create_comment(params) do
      {:ok, _save_comment} ->
        socket = put_flash(socket, :info, "Comment Created Successfully")
        {:noreply, redirect(socket, to: ~p"/gist?id=#{gist_id}")}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, redirect(socket, to: ~p"/gist?id=#{gist_id}")}
    end
  end

  def handle_event("delete_comment", %{"comment_id" => comment_id, "gist_id" => gist_id}, socket) do
    case Comments.delete_comment(socket.assigns.current_user.id, comment_id) do
      {:ok, _comment} ->
        socket = put_flash(socket, :info, "Comment Successfully Deleted")
        {:noreply, push_navigate(socket, to: ~p"/gist?id=#{gist_id}")}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, push_navigate(socket, to: ~p"/gist?id=#{gist_id}")}
    end
  end

  defp create_saved_gist(socket, user_id, gist_id) do
    case Gists.create_saved_gist(%{"user_id" => user_id, "gist_id" => gist_id}) do
      {:ok, _save_gist} ->
        socket = put_flash(socket, :info, "Gist Successfully Saved")
        {:noreply, push_navigate(socket, to: ~p"/gist?id=#{gist_id}")}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, push_navigate(socket, to: ~p"/gist?id=#{gist_id}")}
    end
  end

  defp delete_saved_gist(socket, user_id, gist_id) do
    case Gists.delete_saved_gist(user_id, gist_id) do
      {1, _} ->
        socket = put_flash(socket, :info, "Saved gist successfully deleted!")
        {:noreply, redirect(socket, to: ~p"/gist?id=#{gist_id}")}

      _ ->
        socket = put_flash(socket, :error, "Something went wrong while deleting the gist!")
        {:noreply, redirect(socket, to: ~p"/gist?id=#{gist_id}")}
    end
  end
end
