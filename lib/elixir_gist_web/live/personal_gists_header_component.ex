defmodule ElixirGistWeb.PersonalGistsHeaderComponent do
  use ElixirGistWeb, :live_component

  # def mount(_params, _session, socket) do
  #   {:ok, socket}
  # end

  def render(assigns) do
    ~H"""
    <div class="eg-gradient flex flex-col items-center justify-center px-[104px] lg:px-[200px]">
      <div class="flex justify-start items-center mx-auto w-full">
        <div class={[
          "font-brand font-bold text-3xl text-white py-4 px-3",
          @path == "/your_gists" && "border-b-4 border-pink-400 pb-3"
        ]}>
          <.link navigate={~p"/your_gists"} class="block">
            &lt;/&gt; Your gists
          </.link>
        </div>
        <div class={[
          "flex gap-2 items-center font-brand font-bold text-3xl text-white py-4 px-3",
          @path == "/saved_gists" && "border-b-4 border-pink-400 pb-3"
        ]}>
          <img src="/images/BookmarkOutline.svg" alt="Save Button" />

          <.link navigate={~p"/saved_gists"} class="block">
            Saved
          </.link>
        </div>
      </div>
      <hr class="border-t-[1px] border-pink-400 w-full" />
    </div>
    """
  end
end
