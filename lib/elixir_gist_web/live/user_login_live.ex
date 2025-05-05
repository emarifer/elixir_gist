defmodule ElixirGistWeb.UserLoginLive do
  use ElixirGistWeb, :live_view

  alias Phoenix.LiveView.JS

  def render(assigns) do
    ~H"""
    <div class="eg-gradient flex flex-col items-center justify-center">
      <h1 class="font-brand font-bold text-3xl text-white py-2">
        Sign in to account
      </h1>
      <h3 class="font-brand font-bold text-lg text-white">
        Don't have an account?
        <.link
          navigate={~p"/users/register"}
          class="font-semibold text-brand hover:underline text-egLavender-dark"
        >
          Sign up
        </.link>
        for an account now.
      </h3>
    </div>
    <div class="mx-auto max-w-sm">
      <.simple_form
        for={@form}
        id="login_form"
        action={~p"/users/log_in"}
        phx-update="ignore"
        class="bg-transparent"
      >
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
            phx-click={
              JS.toggle_class("hero-eye",
                to: {:inner, "span"},
                transition: {"ease-out duration-75", "hero-eye", "hero-eye-slash"}
              )
            }
            phx-hook="ShowPassword"
            title="Show password"
          >
            <.icon
              name="hero-eye"
              class="bg-egDark-light w-5 h-5 absolute inset-y-0 end-0 z-20 px-4 my-auto cursor-pointer"
            />
          </div>
        </div>

        <div class="flex items-center justify-between py-4">
          <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
          <.link
            navigate={~p"/users/reset_password"}
            class="text-sm font-brand text-egDark-light font-semibold hover:underline"
          >
            Forgot your password?
          </.link>
        </div>
        <.button phx-disable-with="Logging in…" class="create-button w-full">
          Sign in <span aria-hidden="true">→</span>
        </.button>
      </.simple_form>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form, page_title: "Sign in"), temporary_assigns: [form: form]}
  end
end

# <div phx-click={JS.toggle_attribute({"type", "text", "password"}, to: "#password")}>
#   <div phx-click={JS.toggle_class("hero-eye", to: {:inner, "span"})}>
#     <.icon
#     class="block bg-egDark-light w-5 h-5 absolute inset-y-0 end-0 z-20 px-4 my-auto cursor-pointer"
#     name="hero-eye-slash"
#     />
#   </div>
# </div>

# REFERENCES:
# https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.JS.html
# https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.JS.html#toggle_class/3
# https://hexdocs.pm/phoenix_live_view/js-interop.html
#
# https://www.javascripttutorial.net/javascript-dom/javascript-toggle-password-visibility/
# https://www.geeksforgeeks.org/show-hide-password-using-javascript/
# https://www.w3schools.com/howto/howto_js_toggle_password.asp
