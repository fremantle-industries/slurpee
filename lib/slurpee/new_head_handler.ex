defmodule Slurpee.NewHeadHandler do
  @type blockchain :: Slurp.Blockchains.Blockchain.id()
  @type block_number :: Slurp.Adapter.block_number()

  @callback handle_new_head(blockchain, block_number) :: no_return

  require Logger

  def handle_new_head(blockchain, block_number) do
    Logger.info("received new head: #{block_number}")

    Phoenix.PubSub.broadcast(
      Slurpee.PubSub,
      "heads:new_head_received",
      {"heads:new_head_received", blockchain.id, block_number}
    )
  end
end
