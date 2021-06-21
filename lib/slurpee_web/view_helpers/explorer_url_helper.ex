defmodule SlurpeeWeb.ViewHelpers.ExplorerUrlHelper do
  import Stylish.ExternalLink, only: [external_link: 1]

  def explorer_url({explorer_adapter, endpoint}) do
    url = explorer_adapter.home_url(endpoint)
    external_link(to: url)
  end

  def explorer_url(nil) do
    "-"
  end
end
