defmodule ElixirGistWeb.UserRegistrationLive do
  use ElixirGistWeb, :live_view

  alias ElixirGist.Accounts
  alias ElixirGist.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="eg-gradient flex flex-col items-center justify-center">
      <h1 class="font-brand font-bold text-3xl text-white py-2">
        Register for an account
      </h1>
      <h3 class="font-brand font-bold text-lg text-white">
        Already registered?
        <.link
          navigate={~p"/users/log_in"}
          class="font-semibold text-brand hover:underline text-egLavender-dark"
        >
          Sign in
        </.link>
        to your account now.
      </h3>
    </div>
    <div class="mx-auto max-w-sm">
      <.simple_form
        for={@form}
        id="registration_form"
        phx-submit="save"
        phx-change="validate"
        phx-trigger-action={@trigger_submit}
        action={~p"/users/log_in?_action=registered"}
        method="post"
        class="bg-transparent"
      >
        <.error :if={@check_errors}>
          Oops, something went wrong! Please check the errors below.
        </.error>

        <.input field={@form[:email]} type="email" placeholder="Email" required />
        <div class="relative mt-2">
          <.input
            id="password"
            field={@form[:password]}
            type="password"
            class="block w-full rounded-lg text-zinc-900 focus:ring-0 sm:text-sm sm:leading-6 pr-10"
            placeholder="Password"
            required
          />
          <div
            id="show-hide-pass"
            phx-click={JS.toggle_class("hero-eye-slash", to: {:inner, "span"})}
            phx-hook="ShowPassword"
            title="Show password"
          >
            <.icon
              name="hero-eye"
              class="bg-egDark-light mt-1.5 w-5 h-5 absolute inset-y-0 end-0 z-20 px-4 cursor-pointer"
            />
          </div>
        </div>

        <div class="py-6">
          <.button phx-disable-with="Creating account…" class="create-button w-full">
            Create an account
          </.button>
        </div>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    changeset = Accounts.change_user_registration(%User{})

    socket =
      socket
      |> assign(trigger_submit: false, check_errors: false, page_title: "Sign up")
      |> assign_form(changeset)

    {:ok, socket, temporary_assigns: [form: nil]}
  end

  def handle_event("save", %{"user" => user_params}, socket) do
    case Accounts.register_user(user_params) do
      {:ok, user} ->
        {:ok, _} =
          Accounts.deliver_user_confirmation_instructions(
            user,
            &url(~p"/users/confirm/#{&1}")
          )

        changeset = Accounts.change_user_registration(user)
        {:noreply, socket |> assign(trigger_submit: true) |> assign_form(changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, socket |> assign(check_errors: true) |> assign_form(changeset)}
    end
  end

  def handle_event("validate", %{"user" => user_params}, socket) do
    changeset = Accounts.change_user_registration(%User{}, user_params)
    {:noreply, assign_form(socket, Map.put(changeset, :action, :validate))}
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    form = to_form(changeset, as: "user")

    if changeset.valid? do
      assign(socket, form: form, check_errors: false)
    else
      assign(socket, form: form)
    end
  end
end
