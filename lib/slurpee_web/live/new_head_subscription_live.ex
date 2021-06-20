defmodule SlurpeeWeb.NewHeadSubscriptionLive do
  use SlurpeeWeb, :live_view
  import SlurpeeWeb.ViewHelpers.SearchQueryHelper, only: [assign_search_query: 2]

  @impl true
  def mount(_params, _session, socket) do
    socket =
      socket
      |> assign(:query, nil)

    {:ok, socket}
  end

  @impl true
  def handle_params(params, _uri, socket) do
    socket =
      socket
      |> assign_search_query(params)
      |> assign_search()

    {:noreply, socket}
  end

  @impl true
  def handle_event("search", params, socket) do
    socket =
      socket
      |> assign_search_query(params)
      |> send_search_after(200)

    {:noreply, socket}
  end

  @impl true
  def handle_info(:search, socket) do
    socket =
      socket
      |> assign(:search_timer, nil)
      |> assign_search()

    {:noreply, socket}
  end

  defp send_search_after(socket, after_ms) do
    if socket.assigns[:search_timer] do
      socket
    else
      timer = Process.send_after(self(), :search, after_ms)
      assign(socket, :search_timer, timer)
    end
  end

  defp assign_search(socket) do
    socket
    |> assign(new_head_subscriptions: search_new_head_subscriptions(socket.assigns.query))
  end

  defp search_new_head_subscriptions(search_term) do
    []
    |> Slurp.Commander.new_head_subscriptions()
    |> search_new_head_subscriptions(search_term)
  end

  defp search_new_head_subscriptions(new_head_subscriptions, nil) do
    new_head_subscriptions
  end

  defp search_new_head_subscriptions(new_head_subscriptions, search_term) do
    new_head_subscriptions
    |> Enum.filter(fn s ->
      String.contains?(s.blockchain_id, search_term) ||
        String.contains?(s.enabled |> to_string(), search_term) ||
        String.contains?(s.handler |> inspect(), search_term)
    end)
  end
end
