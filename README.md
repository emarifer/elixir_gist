# ElixirGist

<div align="center">


### A GitHub Gist clone built with the [`Elixir`](https://elixir-lang.org/) language's [`Phoenix`](https://www.phoenixframework.org/) framework to learn and test its capabilities.

<br />


> 🚧 This is a page under construction and therefore does not yet show all
> the information related to the application.

<br />
  
![GitHub License](https://img.shields.io/github/license/emarifer/elixir_gist) ![Static Badge](https://img.shields.io/badge/Elixir-%3E=1.18-6e4a7e) ![Static Badge](https://img.shields.io/badge/Erlang/OTP-%3E=27-B83998) ![Static Badge](https://img.shields.io/badge/PhoenixFramework-%3E=1.7.21-fd4f00)

</div>

<hr />

### Features 🚀

- [x] **General features:** : This is a [`GitHub Gist`](https://gist.github.com/discover) clone with reduced features, i.e., a **minimum viable product** (MVP). From there, any dev could plan and implement new features that would expand their capabilities. In any case, with `Elixir Gist` we can create a user account (the entire authentication system is automatically implemented by Phoenix upon project creation, thanks to the fantastic set of tools provided by both `Elixir` and the `Phoenix framework` itself, with, in most cases, little modification required to adapt it to our particular use case), and account confirmation via email; the authentication system will ensure the protection of views that require a logged-in user. Once inside the application, we can create code snippets whose syntax will be highlighted by the [`highlight.js`](https://highlightjs.org/) library (this library promises syntax highlighting for 192 languages ​​with 498 themes). These snippets can be copied/shared by any user, and their creator can edit/delete them. We can search all snippets stored in the database by name or description. This view displays pagination, sorting Gists in descending order by update date and time, and displays a summary preview of the snippet. We'll also have a view that shows only the snippets the current user has created or those they've saved as favorites. Finally, in the view that shows the full snippet, in addition to allowing the user who created it to edit/delete it, we can also save it as a favorite (or remove it from that list) and add comments, which are saved using `Markdown` syntax, making the result more elegant than just plain text.
- [x] **Using Phoenix framework + Phoenix LiveView:** The union of `Phoenix` with its subsidiary library [`LiveView`](https://hexdocs.pm/phoenix_live_view) creates, in the opinion of many, the best web framework on the market. LiveView enables rich, real-time user experiences with server-rendered HTML, offering a unified experience for building web applications. There's no longer a need to split work between the client and server, or across different tools, layers, and abstractions (see [here](https://github.com/phoenixframework/phoenix_live_view?tab=readme-ov-file#phoenix-liveview) for a more detailed explanation of its capabilities and features). The magic behind this technology, which enables server-side rendering (improving `SEO`) without the need for page reloads (and a better UX), lies in the use of `websockets`. In some cases, it's true that you'll need to code some `JavaScript` (well, it's not that bad… many of us come from there 😜) so you don't have to "bother" the server with a simple change you want to display in your interface. In any case, the `full-stack` developer experience will always be very rewarding.
- [x] **Using Elixir and Phoenix framework**: Well, what can we say about `Elixir`… the documentation and other sources state that "Elixir is a general-purpose, concurrent, functional programming language that runs on the `Erlang Virtual Machine` (`BEAM`), process-oriented and compiles to `bytecode` for that VM, known for building distributed, low-latency, fault-tolerant systems. Elixir is written on top of Erlang and shares the same abstractions for developing distributed. Elixir also provides extensible design with productivity tools. It includes support for compile-time `metaprogramming` with `macros` and `polymorphism` over `protocols`. These capabilities and Elixir's tools enable developers to be productive in diverse fields, including web development, embedded software, machine learning, data pipelines, and multimedia processing, across a wide range of industries". In short, for an average developer, Elixir is a comfortable, productive, robust and elegant language.

---

### 👨‍🚀 Getting Started:

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

### Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

---

### Happy coding 😀!!
