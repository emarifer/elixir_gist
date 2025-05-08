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
import hljs from "highlight.js"
import markdownit from "markdown-it"
// Include phoenix_html to handle method=PUT/DELETE in forms and buttons.
import "phoenix_html"
// Establish Phoenix Socket and LiveView configuration.
import { Socket } from "phoenix"
import { LiveSocket } from "phoenix_live_view"
import topbar from "../vendor/topbar"

// https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Default_parameters
// https://stackoverflow.com/questions/384286/how-do-you-check-if-a-javascript-object-is-a-dom-object
function updateLineNumbers(value, lineNumberText) {
  if (!lineNumberText) return;

  const lines = value.split("\n");
  const numbers = lines.map((_, index) => index + 1).join("\n") + "\n";

  if (lineNumberText instanceof Element) {
    lineNumberText.value = numbers;
  }
};

let Hooks = {};

// https://www.javascripttutorial.net/javascript-dom/javascript-siblings/
// https://uibakery.io/regex-library/uuid
// https://www.w3schools.com/jsref/jsref_includes_array.asp
Hooks.Highlight = {
  mounted() {
    // const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-5][0-9a-f]{3}-[089ab][0-9a-f]{3}-[0-9a-f]{12}$/i;
    let name = this.el.getAttribute("data-name");
    let codeBlock = this.el.querySelector("pre code");

    if (name && codeBlock) {
      codeBlock.className = codeBlock.className.replace(/language-\S+/g, "");
      codeBlock.classList.add(`language-${this.getSyntaxType(name)}`);
      trimmed = this.trimCodeBlock(codeBlock);
      hljs.highlightElement(trimmed);
      updateLineNumbers(trimmed.textContent, this.el.previousElementSibling);
    }
  },

  getSyntaxType(name) {
    let extension = name.split(".").pop();

    switch (extension) {
      case "text":
        return "text";
      case "json":
        return "json";
      case "html":
        return "html";
      case "heex":
        return "html";
      case "js":
        return "javascript";
      default:
        return "elixir";
    }
  },

  trimCodeBlock(codeBlock) {
    const lines = codeBlock.textContent.split("\n");
    if (lines.lenght > 2) {
      lines.shift();
      lines.pop();
    }
    codeBlock.textContent = lines.join("\n");

    return codeBlock;
  }
};

Hooks.UpdateLineNumbers = {
  mounted() {
    // https://stackoverflow.com/questions/61932601/dom-css-selector-how-to-select-a-sibling-of-a-parent-element-if-the-li-has-acti
    const lineNumberText = this.el.parentElement.parentElement.previousElementSibling;
    const createButton = document.querySelector(".create-button");
    let keyPressed = {};

    this.el.addEventListener("input", () => {
      updateLineNumbers(this.el.value, lineNumberText)
    })

    this.el.addEventListener("scroll", () => {
      // This way, the two text areas will run in parallel
      // when the text area in which we write scrolls automatically.
      lineNumberText.scrollTop = this.el.scrollTop;
    })

    this.el.addEventListener("keydown", (e) => {
      // https://stackoverflow.com/questions/20962033/how-can-i-catch-2-key-presses-at-once
      keyPressed[e.key] = true;
      if (keyPressed["Control"] && keyPressed["Shift"] && keyPressed["F"]) {
        keyPressed = {};
        createButton.focus();
      }

      if (e.key == "Tab") {
        e.preventDefault();
        // https://developer.mozilla.org/en-US/docs/Web/API/HTMLInputElement/selectionStart
        const start = this.el.selectionStart;
        const end = this.el.selectionEnd;
        // we add a tab character at the cursor position.
        this.el.value = this.el.value.substring(0, start) + "\t" + this.el.value.substring(end)
        // we update the cursor position by one character, that is,
        // we place the cursor to the right of the tab character we just added.
        this.el.selectionStart = this.el.selectionEnd = start + 1;
      }
    })

    // See:
    // https://hexdocs.pm/phoenix_live_view/Phoenix.LiveView.html#push_event/3
    this.handleEvent("clear-textareas", () => {
      this.el.value = "";
      lineNumberText.value = "1\n";
    })

    // We also call the update function when mounting our input.
    updateLineNumbers(this.el.value, lineNumberText)
  }
};

Hooks.ToggleEdit = {
  mounted() {
    this.el.addEventListener("click", () => {
      let edit = document.getElementById("edit-section");
      let syntax = document.getElementById("syntax-section");

      if (edit && syntax) {
        edit.style.display = "block";
        syntax.style.display = "none";
      }
    })
  }
}

Hooks.CopyToClipboard = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      const textToCopy = this.el.getAttribute("data-clipboard-gist");

      if (textToCopy) {
        navigator.clipboard.writeText(textToCopy)
          .then(() => alert("Gist copied to clipboard"))
          .catch((err) => console.error("Failed to copy text:", err));
      }
    })
  }
};

Hooks.ShareGist = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      const gistId = this.el.getAttribute("data-share-gist");

      if (gistId) {
        navigator.clipboard.writeText(`${location.origin}/gist?id=${gistId}`)
          .then(() => alert("Gist link copied to clipboard"))
          .catch((err) => console.error("Failed to copy link:", err));
      }
    })
  }
};

Hooks.CopyCommentLink = {
  mounted() {
    this.el.addEventListener("click", (e) => {
      // Remove the hash if there is one to get a clean URL
      // with only the query parameters
      result = location.href.replace(/#.*/g, "");
      const textToCopy = `${result}#${this.el.getAttribute("data-comment-link")}`;

      if (textToCopy) {
        navigator.clipboard.writeText(textToCopy)
          .then(() => alert("Comment link copied to clipboard"))
          .catch((err) => console.error("Failed to copy text:", err));
      }
    })
  }
};

Hooks.CurrentYear = {
  mounted() {
    this.el.textContent = new Date().getFullYear();
  }
};

Hooks.DateFormat = {
  mounted() {
    const time = this.el.getAttribute("data-time");
    this.el.setAttribute("title", new Date(time));
  }
}

// https://hexdocs.pm/phoenix_live_view/js-interop.html#client-server-communication
// https://salesforce.stackexchange.com/questions/366317/how-to-catch-the-event-of-clicking-the-clear-button-in-lightning-input-type-s
// https://elixirforum.com/t/sending-events-from-js-to-liveview-component/49800/4
Hooks.ClearSearchInput = {
  mounted() {
    this.el.addEventListener("search", () => {
      if (this.el.value == "") this.pushEvent("reset-search", {})
    })
  }
}

Hooks.HandleMarkdown = {
  mounted() {
    const md = markdownit('commonmark');
    const preview = document.getElementById("text-preview");

    this.el.addEventListener("input", () => {
      if (this.el.value.length == 0) {
        preview.innerHTML = "Nothing to preview"
      } else {
        preview.innerHTML = md.render(this.el.value);
      }
    });
  }
}

Hooks.FormatMarkdown = {
  mounted() {
    const md = markdownit('commonmark');

    this.el.innerHTML = md.render(this.el.textContent.trim());
  }
}

// https://elixirforum.com/t/get-value-from-different-element-without-form/40924
Hooks.CreateComment = {
  mounted() {
    const userId = this.el.getAttribute("data-userid");
    const gistId = this.el.getAttribute("data-gistid");
    const textMarkdown = document.getElementById("text-markdown");

    this.el.addEventListener("click", () => {
      if (textMarkdown && !textMarkdown.value) {
        alert("There was a problem saving your comment. Your comment can't be blank. Please try again.");
        return;
      }
      if (userId && gistId && textMarkdown) {
        this.pushEvent("create_comment", {
          markup_text: textMarkdown.value,
          user_id: userId,
          gist_id: gistId
        });
      }
    })
  }
}

// Hook replaced with Phoenix.LiveView.JS commands:
// Hooks.ShowPassword = {
//   mounted() {
//     const password = document.getElementById("password");

//     this.el.addEventListener("click", () => {
//       const type = password.getAttribute("type") === "password" ? "text" : "password";
//       const title = this.el.getAttribute("title") === "Show password" ? "Hide password" : "Show password";
//       password.setAttribute("type", type);
//       this.el.setAttribute("title", title);
//     })
//   }
// }

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

