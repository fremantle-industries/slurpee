defmodule SlurpeeWeb.BlockchainLive do
  use SlurpeeWeb, :live_view
  import SlurpeeWeb.ViewHelpers.SearchQueryHelper, only: [assign_search_query: 2]
  import SlurpeeWeb.ViewHelpers.ExplorerUrlHelper, only: [explorer_url: 1]

  @impl true
  def mount(_params, _session, socket) do
    Phoenix.PubSub.subscribe(Slurpee.PubSub, "new_head_received")

    socket =
      socket
      |> assign(:query, nil)
      |> assign(latest_blocks: %{})

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
  def handle_event("start", %{"id" => blockchain_id}, socket) do
    Slurp.Commander.start_blockchains(where: [id: blockchain_id])
    blockchains = Slurp.Commander.blockchains([])

    socket =
      socket
      |> assign(blockchains: blockchains)

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop", %{"id" => blockchain_id}, socket) do
    Slurp.Commander.stop_blockchains(where: [id: blockchain_id])
    blockchains = Slurp.Commander.blockchains([])

    socket =
      socket
      |> assign(blockchains: blockchains)

    {:noreply, socket}
  end

  @impl true
  def handle_event("start-all", _, socket) do
    Slurp.Commander.start_blockchains([])
    blockchains = Slurp.Commander.blockchains([])

    socket =
      socket
      |> assign(blockchains: blockchains)

    {:noreply, socket}
  end

  @impl true
  def handle_event("stop-all", _, socket) do
    Slurp.Commander.stop_blockchains([])
    blockchains = Slurp.Commander.blockchains([])

    socket =
      socket
      |> assign(blockchains: blockchains)

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

  @impl true
  def handle_info({"new_head_received", blockchain_id, block_number}, socket) do
    latest_blocks =
      socket.assigns.latest_blocks
      |> Map.put(blockchain_id, block_number)

    {:noreply, assign(socket, latest_blocks: latest_blocks)}
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
    |> assign(blockchains: search_blockchains(socket.assigns.query))
  end

  defp search_blockchains(search_term) do
    []
    |> Slurp.Commander.blockchains()
    |> search_blockchains(search_term)
  end

  defp search_blockchains(blockchains, nil) do
    blockchains
  end

  defp search_blockchains(blockchains, search_term) do
    blockchains
    |> Enum.filter(fn b ->
      String.contains?(b.id, search_term) ||
        String.contains?(b.name, search_term) ||
        String.contains?(b.status |> Atom.to_string(), search_term) ||
        String.contains?(b.network_id |> to_string(), search_term) ||
        String.contains?(b.chain_id |> to_string(), search_term) ||
        String.contains?(b.chain, search_term) ||
        String.contains?(b.testnet |> to_string(), search_term)
    end)
  end

  defp running?(%Slurp.Commander.Blockchains.ListItem{status: :running}), do: true
  defp running?(_), do: false

  defp none_running?(blockchains), do: running_count(blockchains) == 0

  defp all_running?(blockchains), do: running_count(blockchains) == length(blockchains)

  defp running_count(blockchains) do
    blockchains
    |> Enum.filter(&running?/1)
    |> Enum.count()
  end
end
