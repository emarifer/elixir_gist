defmodule ElixirGistWeb.CommentComponent do
  use ElixirGistWeb, :live_component

  alias ElixirGistWeb.Utilities.DateFormat

  def render(assigns) do
    ~H"""
    <div class="flex justify-between items-start mx-28 mb-10 mt-[6px] lg:mx-52">
      <img src="/images/user-image.svg" alt="Profile Image" class="round-image-padding w-8 h-8" />

      <div class="w-full ml-5">
        <a name={"comment_id=#{@comment.id}"}>
          <div class="relative speech-bubble-border"></div>
        </a>
        <div class="relative speech-bubble flex justify-between bg-egDark text-sm font-medium text-white px-3 py-2 rounded-t-lg border border-egDark-light">
          <div class="flex gap-4">
            {@comment.user.email}
            <span class="font-thin">
              commented {DateFormat.get_relative_time(@comment.updated_at)}
            </span>
          </div>
          <%!-- https://elixirforum.com/t/easy-confirm-action-in-phoenix-for-click-submit-etc/64847/11 --%>
          <div class="flex gap-2 items-center">
            <button
              :if={@user_id == @comment.user_id}
              title="Delete comment"
              class="px-1 hover:brightness-75 active:scale-110"
              type="button"
              phx-click="delete_comment"
              phx-value-comment_id={@comment.id}
              phx-value-gist_id={@gist_id}
              data-confirm="Are you sure you want to delete this comment?"
            >
              <img src="/images/delete.svg" alt="Delete Button" />
            </button>

            <button
              id={"copy-btn-#{@comment.id}"}
              title="Copy comment link to clipboard"
              class="px-1 hover:brightness-75 active:scale-110"
              type="button"
              phx-hook="CopyCommentLink"
              data-comment-link={"comment_id=#{@comment.id}"}
            >
              <.icon class="bg-white w-4 h-4" name="hero-link" />
            </button>
          </div>
        </div>
        <div class="min-h-20 bg-egDark-dark text-sm font-light text-white p-4 rounded-b-lg border border-t-0 border-egDark-light">
          <div class="reset-tw" id={@comment.id} phx-hook="FormatMarkdown">
            {@comment.markup_text}
          </div>
        </div>
      </div>
    </div>
    """
  end
end
