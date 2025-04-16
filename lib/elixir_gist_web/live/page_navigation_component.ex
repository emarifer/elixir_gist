defmodule ElixirGistWeb.PageNavigationComponent do
  use ElixirGistWeb, :live_component

  # def mount(socket) do
  #   {:ok, socket}
  # end

  def render(assigns) do
    ~H"""
    <nav class="flex gap-4 items-center p-0.5 text-sm text-white w-fit mx-auto">
      <.link
        :if={@page_number > 1}
        navigate={~p"/all?#{%{page: @page_number - 1}}"}
        class="block hover:underline"
      >
        <span class="text-base font-bold text-egLavender-dark">‹‹</span> Previous
      </.link>

      <div class="flex gap-1 text-sm text-white">
        <.link :for={idx <- Enum.to_list(1..@total_pages)} navigate={~p"/all?#{%{page: idx}}"}>
          <span class={[
            "px-2",
            @page_number == idx && "bg-egLavender-dark rounded-md border border-white"
          ]}>
            {idx}
          </span>
        </.link>
      </div>

      <.link
        :if={@page_number < @total_pages}
        navigate={~p"/all?#{%{page: @page_number + 1}}"}
        class="block hover:underline"
      >
        Next <span class="text-base font-bold text-egLavender-dark">››</span>
      </.link>
    </nav>
    """
  end
end
