defmodule ElixirGistWeb.Exceptions.NotFoundError do
  defexception [:message, plug_status: 404]
end
