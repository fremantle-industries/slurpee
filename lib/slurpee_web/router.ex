defmodule SlurpeeWeb.Router do
  use SlurpeeWeb, :router
  import Redirect

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

  redirect "/", "/home", :permanent

  scope "/", SlurpeeWeb do
    pipe_through :browser

    live_session :default do
      live "/home", HomeLive, :index
      live "/blockchains", BlockchainLive, :index
      live "/log_subscriptions", LogSubscriptionLive, :index
      live "/new_head_subscriptions", NewHeadSubscriptionLive, :index
      live "/transactions", TransactionSubscriptionLive, :index
    end
  end

  scope "/", NotifiedPhoenix do
    pipe_through :browser

    live_session :notifications, root_layout: {SlurpeeWeb.LayoutView, :root} do
      live("/notifications", ListLive, :index, as: :notification)
    end
  end
end
