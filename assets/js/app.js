// If you want to use Phoenix channels, run `mix help phx.gen.channel`
// to get started and then uncomment the line below.
// import "./user_socket.js"

// You can include dependencies in two ways.
//
// The simplest option is to put them in assets/vendor and
// import them using relative paths:
//
//     import "../vendor/some-package.js"
//
// Alternatively, you can `npm install some-package --prefix assets` and import
// them using a path starting with the package name:
//
//     import "some-package"
//

// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

let Hooks = {};

Hooks.UpdateLineNumbers = {
  mounted() {
    this.el.addEventListener("input", () => {
      this.updateLineNumbers()
    })

    this.el.addEventListener("scroll", () => {
      const lineNumberText = document.querySelector("#line-numbers");

      // This way, the two text areas will run in parallel
      // when the text area in which we write scrolls automatically.
      lineNumberText.scrollTop = this.el.scrollTop;
    })

    // We also call the update function when mounting our input.
    this.updateLineNumbers()
  },

  updateLineNumbers() {
    const lineNumberText = document.querySelector("#line-numbers");
    if (!lineNumberText) return;

    // `this` is the element to which the hook is attached,
    // in this case, the text area attached to `#line-numbers`
    // in which we put our code.
    const lines = this.el.value.split("\n");
    const numbers = lines.map((_, index) => index + 1).join("\n") + "\n";

    lineNumberText.value = numbers;
  }
};

let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")
let liveSocket = new LiveSocket("/live", Socket, {
  longPollFallbackMs: 2500,
  params: { _csrf_token: csrfToken },
  hooks: Hooks,
})

// Show progress bar on live navigation and form submits
topbar.config({ barColors: { 0: "#29d" }, shadowColor: "rgba(0, 0, 0, .3)" })
window.addEventListener("phx:page-loading-start", _info => topbar.show(300))
window.addEventListener("phx:page-loading-stop", _info => topbar.hide())

// connect if there are any LiveViews on the page
liveSocket.connect()

// expose liveSocket on window for web console debug logs and latency simulation:
// >> liveSocket.enableDebug()
// >> liveSocket.enableLatencySim(1000)  // enabled for duration of browser session
// >> liveSocket.disableLatencySim()
window.liveSocket = liveSocket

