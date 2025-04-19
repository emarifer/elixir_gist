defmodule ElixirGistWeb.GistPreviewComponent do
  use ElixirGistWeb, :live_component

  alias ElixirGistWeb.Utilities.{CodePreview, DateFormat}

  # def mount(socket) do
  #   {:ok, socket}
  # end

  # https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#c:render/1
  # https://v3.tailwindcss.com/docs/flex-grow
  def render(assigns) do
    ~H"""
    <div class="justify-center px-28 w-full mb-20 lg:px-52">
      <div class="flex justify-between mb-4">
        <div class="flex items-start">
          <img
            src="/images/user-image.svg"
            alt="Profile Image"
            class="round-image-padding w-8 h-8 flex-none mt-1.5"
          />
          <div class="flex flex-col ml-4">
            <div class="font-bold text-base text-egLavender-dark hover:underline">
              <.link navigate={~p"/gist?#{[id: @gist]}"}>
                {@gist.user.email}<span class="text-white"> / </span>{@gist.name}
              </.link>
            </div>
            <div class="font-bold text-lg text-white">
              {DateFormat.get_relative_time(@gist.updated_at)}
            </div>
            <p class="text-sm text-white">
              {@gist.description}
            </p>
          </div>
        </div>
        <div class="flex items-start gap-3">
          <div class="flex items-center">
            <img src="/images/comment.svg" alt="Comment Count" class="w-5 h-5" />
            <span class="text-white text-sm px-1">0</span>
          </div>
          <div class="flex items-center">
            <img src="/images/BookmarkOutline.svg" alt="Bookmark Count" class="w-5 h-5" />
            <span class="text-white text-sm px-1">{@gist.saved_count}</span>
          </div>
        </div>
      </div>

      <div class="flex w-full">
        <textarea
          class="border border-white font-brand py-2.5 text-xs text-egDark-light bg-egSyntax h-auto w-[54px] text-right overflow-hidden resize-none rounded-bl-md rounded-tl-md border-r-0 focus:outline-none focus:border-white focus:ring-0"
          readonly
        >
    </textarea>
        <div
          id={@gist.id}
          class="bg-egSyntax text-xs border border-white border-l-0 h-auto w-full rounded-br-md rounded-tr-md overflow-x-scroll scroller"
          phx-hook="Highlight"
          data-name={@gist.name}
        >
          <pre><code class="language-elixir">{CodePreview.get_preview_text(@gist)}</code></pre>
        </div>
      </div>
    </div>
    """
  end
end
