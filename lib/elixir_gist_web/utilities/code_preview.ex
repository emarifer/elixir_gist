defmodule ElixirGistWeb.Utilities.CodePreview do
  # https://til.hashrocket.com/posts/d75339a700-named-captures-with-elixir-regular-expressions
  def get_preview_text(gist) when not is_nil(gist.markup_text) do
    lines = gist.markup_text |> String.split("\n")

    if length(lines) > 10 do
      regex = ~r/(?<bs>^\s+)/
      [line1 | _] = lines
      %{"bs" => bs} = Regex.named_captures(regex, line1)

      (Enum.take(lines, 9) ++ [bs <> "..."]) |> Enum.join("\n")
    else
      gist.markup_text
    end
  end

  def get_preview_text(_gist), do: ""
end
