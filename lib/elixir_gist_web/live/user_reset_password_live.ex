defmodule ElixirGistWeb.UserResetPasswordLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Accounts

  def render(assigns) do
    ~H"""
    <div class="eg-gradient flex flex-col items-center justify-center">
      <h1 class="font-brand font-bold text-3xl text-white py-2">
        Reset Password
      </h1>
    </div>
    <div class="mx-auto max-w-sm">
      <.simple_form
        for={@form}
        id="reset_password_form"
        phx-submit="reset_password"
        phx-change="validate"
        class="bg-transparent"
      >
        <.error :if={@form.errors != []}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:password]} type="password" placeholder="New password" required />
        <.input
          field={@form[:password_confirmation]}
          type="password"
          placeholder="Confirm new password"
          required
        />
        <div class="pt-6">
          <.button phx-disable-with="Resetting…" class="create-button w-full">
            Reset Password
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

  def mount(params, _session, socket) do
    socket = assign_user_and_token(socket |> assign(:page_title, "Reset password"), params)

    form_source =
      case socket.assigns do
        %{user: user} ->
          Accounts.change_user_password(user)

        _ ->
          %{}
      end

    {:ok, assign_form(socket, form_source), temporary_assigns: [form: nil]}
  end

  # Do not log in the user after reset password to avoid a
  # leaked token giving the user access to the account.
  def handle_event("reset_password", %{"user" => user_params}, socket) do
    case Accounts.reset_user_password(socket.assigns.user, user_params) do
      {:ok, _} ->
        {:noreply,
         socket
         |> put_flash(:info, "Password reset successfully.")
         |> redirect(to: ~p"/users/log_in")}

      {:error, changeset} ->
        {:noreply, assign_form(socket, Map.put(changeset, :action, :insert))}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_password(socket.assigns.user, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_user_and_token(socket, %{"token" => token}) do
    if user = Accounts.get_user_by_reset_password_token(token) do
      assign(socket, user: user, token: token)
    else
      socket
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: ~p"/")
    end
  end

  defp assign_form(socket, %{} = source) do
    assign(socket, :form, to_form(source, as: "user"))
  end
end
