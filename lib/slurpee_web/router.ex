defmodule SlurpeeWeb.Router do
  use SlurpeeWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {SlurpeeWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", SlurpeeWeb do
    pipe_through :browser

    live "/", HomeLive, :index
    live "/blockchains", BlockchainLive, :index
    live "/log_subscriptions", LogSubscriptionLive, :index
    live "/new_head_subscriptions", NewHeadSubscriptionLive, :index
    live "/transactions", TransactionSubscriptionLive, :index
  end

  scope "/", NotifiedPhoenix do
    pipe_through :browser

    live("/notifications", ListLive, :index,
      as: :notification,
      layout: {SlurpeeWeb.LayoutView, :root}
    )
  end
end
