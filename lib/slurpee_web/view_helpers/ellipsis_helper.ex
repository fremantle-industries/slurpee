defmodule SlurpeeWeb.ViewHelpers.EllipsisHelper do
  def ellipsis(str, max_len) do
    if String.length(str) > max_len do
      range = Range.new(0, max_len)
      "#{String.slice(str, range)}..."
    else
      str
    end
  end
end
