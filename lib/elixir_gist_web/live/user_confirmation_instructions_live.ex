defmodule ElixirGistWeb.UserConfirmationInstructionsLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Accounts

  def render(assigns) do
    ~H"""
    <div class="eg-gradient flex flex-col items-center justify-center">
      <h1 class="font-brand font-bold text-3xl text-white py-2">
        No confirmation instructions received?
      </h1>
      <h3 class="font-brand font-bold text-lg text-white">
        We'll send a new confirmation link to your inbox
      </h3>
    </div>

    <div class="mx-auto max-w-sm">
      <.simple_form
        for={@form}
        id="resend_confirmation_form"
        phx-submit="send_instructions"
        class="bg-transparent"
      >
        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <div class="pt-6">
          <.button phx-disable-with="Sending…" class="create-button w-full">
            Resend confirmation instructions
          </.button>
        </div>
      </.simple_form>

      <p class="text-center text-lg font-brand font-bold text-white mt-4">
        <.link navigate={~p"/users/register"} class="text-egLavender-dark hover:underline">
          Register
        </.link>
        |
        <.link navigate={~p"/users/log_in"} class="text-egLavender-dark hover:underline">
          Log in
        </.link>
      </p>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, assign(socket, form: to_form(%{}, as: "user"), page_title: "Confirmation instructions")}
  end

  def handle_event("send_instructions", %{"user" => %{"email" => email}}, socket) do
    if user = Accounts.get_user_by_email(email) do
      Accounts.deliver_user_confirmation_instructions(
        user,
        &url(~p"/users/confirm/#{&1}")
      )
    end

    info =
      "If your email is in our system and it has not been confirmed yet, you will receive an email with instructions shortly."

    {:noreply,
     socket
     |> put_flash(:info, info)
     |> redirect(to: ~p"/")}
  end
end
