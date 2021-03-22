defmodule SlurpeeWeb.TransactionSubscriptionLive do
  use SlurpeeWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    transaction_subscriptions = []

    socket =
      socket
      |> assign(transaction_subscriptions: transaction_subscriptions)

    {:ok, socket}
  end
end
