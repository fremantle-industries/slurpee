defmodule SlurpeeWeb.BlockNumberComponent do
  use Phoenix.HTML

  def pill(assigns) do
    ~E"""
    <span class="rounded-full py-1 px-2 align-middle text-xs font-bold bg-gray-900 text-white">
      <%= @block_number %>
    </span>
    """
  end
end
