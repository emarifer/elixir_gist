defmodule ElixirGistWeb.GistFormComponent do
  use ElixirGistWeb, :live_component

  alias ElixirGist.{Gists, Gists.Gist}

  # See note0 below
  def mount(socket) do
    {:ok, socket}
  end

  def handle_event("validate", %{"gist" => params}, socket) do
    changeset =
      %Gist{}
      |> Gists.change_gist(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("create", %{"gist" => params}, socket) do
    if params["id"] == "new" do
      create_gist(params, socket)
    else
      update_gist(params, socket)
    end
  end

  defp create_gist(params, socket) do
    case Gists.create_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        # See note1 below
        socket = push_event(socket, "clear-textareas", %{})
        changeset = Gists.change_gist(%Gist{})
        socket = assign(socket, :form, to_form(changeset))
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist]}")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp update_gist(params, socket) do
    case Gists.update_gist(socket.assigns.current_user, params) do
      {:ok, gist} ->
        {:noreply, push_navigate(socket, to: ~p"/gist?#{[id: gist]}")}

      {:error, message} ->
        socket = put_flash(socket, :error, message)
        {:noreply, socket}
    end
  end

  # See note2 below
  def render(assigns) do
    ~H"""
    <div>
      <.form
        for={@form}
        phx-submit="create"
        phx-change="validate"
        phx-target={@myself}
        class="lg:px-24"
      >
        <div class="justify-center px-28 w-full space-y-4">
          <.input type="hidden" field={@form[:id]} value={@id} />
          <.input
            field={@form[:description]}
            placeholder="Gist description…"
            autocomplete="off"
            phx-debounce="blur"
          />
          <div>
            <div class="flex p-2 items-center bg-egDark rounded-t-md border">
              <div class="w-[300px] mb-2">
                <.input
                  field={@form[:name]}
                  placeholder="Filename including extension…"
                  autocomplete="off"
                  phx-debounce="blur"
                />
              </div>
            </div>
            <div id="gist-wrapper" class="w-full" phx-update="ignore">
              <%!-- https://hexdocs.pm/phoenix_live_view/bindings.html#dom-patching --%>
              <div class="flex w-full border border-white border-y-0">
                <textarea
                  class=" border-0 font-brand font-regular text-xs text-egDark-light bg-egDark-dark h-[250px] w-[54px] text-right overflow-hidden resize-none focus:outline-none focus:border-white focus:ring-0"
                  readonly
                >{"1\n"}</textarea>
                <div class="flex-grow">
                  <.input
                    id={@id}
                    phx-hook="UpdateLineNumbers"
                    type="textarea"
                    field={@form[:markup_text]}
                    class="bg-egDark-dark font-brand font-regular text-white text-xs border-0 h-[250px] resize-none w-full rounded-t-none mt-0 focus:outline-none focus:border-white focus:ring-0 flex-grow text-nowrap overflow-x-scroll scroller"
                    placeholder="Insert code…"
                    spellcheck="false"
                    autocomplete="off"
                    phx-debounce="blur"
                  />
                </div>
              </div>
              <div class="pl-2 border border-white bg-egDark rounded-b-md w-full font-brand font-regular text-xs text-egDark-light">
                Use <span class="font-bold">Control+Shift+F</span>
                to exit the editing area and move the focus to the
                <span class="font-bold">Create gist</span>
                button.
              </div>
            </div>
          </div>
          <div class="flex justify-end">
            <%= if @id == :new do %>
              <.button class="create-button" phx-disable-with="Creating…">
                Create gist
              </.button>
            <% else %>
              <.button class="create-button" phx-disable-with="Updating…">
                Update gist
              </.button>
            <% end %>
          </div>
        </div>
      </.form>
    </div>
    """
  end
end

# NOTE0:
# https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html#module-mount-and-update

# NOTE1:
# https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#push_event/3

# NOTE2:
# https://hexdocs.pm/phoenix_live_view/Phoenix.LiveComponent.html#module-events
# https://elixirforum.com/t/how-to-achieve-phx-target-myself-in-heex/58606
# https://elixirforum.com/t/statful-component-must-have-a-static-html-in-root-issue/43643
# https://www.youtube.com/live/qyd88knzsHk?si=9juF39vO0q4g2SHn&t=512

# ADDITIONAL REFERENCES:
# https://adopt-liveview.lubien.dev/guides/live-component/en
