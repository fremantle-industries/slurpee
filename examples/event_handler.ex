defmodule Examples.EventHandler do
  require Logger

  def handle_event(_blockchain, %{"blockNumber" => hex_block_number}= _log, event) do
    {:ok, block_number} = Slurp.Utils.hex_to_integer(hex_block_number)
    Logger.info "received event: #{inspect event}, block_number: #{block_number}"
  end
end
