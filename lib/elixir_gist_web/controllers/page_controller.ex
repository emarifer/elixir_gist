defmodule ElixirGistWeb.PageController do
  use ElixirGistWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    conn
    |> redirect(to: ~p"/create")
  end
end
