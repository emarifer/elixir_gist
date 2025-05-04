defmodule ElixirGistWeb.ErrorHTML do
  @moduledoc """
  This module is invoked by your endpoint in case of errors on HTML requests.

  See config/config.exs.
  """
  use ElixirGistWeb, :html

  # If you want to customize your error pages,
  # uncomment the embed_templates/1 call below
  # and add pages to the error directory:
  #
  #   * lib/elixir_gist_web/controllers/error_html/404.html.heex
  #   * lib/elixir_gist_web/controllers/error_html/500.html.heex
  #
  embed_templates "error_html/*"

  # The default is to render a plain text page based on
  # the template name. For example, "404.html" becomes
  # "Not Found".
  def render(_template, assigns) do
    status = assigns.status
    # message = Phoenix.Controller.status_message_from_template(template)

    resp =
      case status do
        404 ->
          %{
            message: "This is not the web page you are looking for.",
            page_title: "Page Not Found"
          }

        400 ->
          %{message: "Bad Request.", page_title: "Bad Request"}

        _ ->
          %{message: "Internal Server Error.", page_title: "Internal Server Error"}
      end

    fallback(%{status: status, message: resp[:message], page_title: resp[:page_title]})
  end
end

# REFERENCES:
# https://elixirforum.com/t/is-it-possible-to-define-a-fallback-template-for-errorhtml-in-phoenix-1-7/54182/2
