defmodule SlurpeeWeb.BlockNumberComponent do
  use Phoenix.HTML
  import Phoenix.LiveView.Helpers, only: [sigil_H: 2]

  def pill(assigns) do
    ~H"""
    <span class="rounded-full py-1 px-2 align-middle text-xs font-bold bg-gray-900 text-white">
      <%= @block_number %>
    </span>
    """
  end
end
