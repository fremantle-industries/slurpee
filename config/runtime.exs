import Config

# Shared variables
env = config_env() |> Atom.to_string()
http_port = (System.get_env("HTTP_PORT") || "4000") |> String.to_integer()
host = System.get_env("RUBE_HOST") || "slurpee.localhost"

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    "aklUQV064QnGvw4oQ9e+Sp5fmTlkig09P/bxk3AfCSsYHQPDVeHfL9h08XUnr9xY"

live_view_signing_salt = System.get_env("LIVE_VIEW_SIGNING_SALT") || "ecn/jrqJ"

# Slurpee
config :slurpee, SlurpeeWeb.Endpoint,
  http: [port: http_port],
  url: [host: host, port: http_port],
  secret_key_base: secret_key_base,
  render_errors: [view: SlurpeeWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Slurpee.PubSub,
  live_view: [signing_salt: live_view_signing_salt]

# Blockchain Connections
# TODO: The aim is to not need this at all. It should be dynamically configured
config :ethereumex, client_type: :http

# Slurp
config :slurp, blockchains: %{}
config :slurp, new_head_subscriptions: %{}
config :slurp, log_subscriptions: %{}

# Navigation
config :navigator,
  links: %{
    slurpee: [
      %{
        label: "Slurpee",
        link: {SlurpeeWeb.Router.Helpers, :home_path, [SlurpeeWeb.Endpoint, :index]},
        class: "text-4xl"
      },
      %{
        label: "Blockchains",
        link: {SlurpeeWeb.Router.Helpers, :blockchain_path, [SlurpeeWeb.Endpoint, :index]}
      },
      %{
        label: "Log Subscriptions",
        link: {SlurpeeWeb.Router.Helpers, :log_subscription_path, [SlurpeeWeb.Endpoint, :index]}
      },
      %{
        label: "New Head Subscriptions",
        link:
          {SlurpeeWeb.Router.Helpers, :new_head_subscription_path, [SlurpeeWeb.Endpoint, :index]}
      },
      %{
        label: "Transaction Subscriptions",
        link:
          {SlurpeeWeb.Router.Helpers, :transaction_subscription_path,
           [SlurpeeWeb.Endpoint, :index]}
      }
    ]
  }

# Notifications
config :notified, pubsub_server: Slurpee.PubSub
config :notified, receivers: []

config :notified_phoenix,
  to_list: {SlurpeeWeb.Router.Helpers, :notification_path, [SlurpeeWeb.Endpoint, :index]}

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Optional Configuration
if config_env() == :dev do
  # Set a higher stacktrace during development. Avoid configuring such
  # in production as building large stacktraces may be expensive.
  config :phoenix, :stacktrace_depth, 20

  # Initialize plugs at runtime for faster development compilation
  config :phoenix, :plug_init_mode, :runtime

  # For development, we disable any cache and enable
  # debugging and code reloading.
  #
  # The watchers configuration can be used to run external
  # watchers to your application. For example, we use it
  # with webpack to recompile .js and .css sources.
  config :slurpee, SlurpeeWeb.Endpoint,
    debug_errors: true,
    code_reloader: true,
    check_origin: false,
    watchers: [
      npm: [
        "run",
        "watch",
        cd: Path.expand("../assets", __DIR__)
      ]
    ]

  # ## SSL Support
  #
  # In order to use HTTPS in development, a self-signed
  # certificate can be generated by running the following
  # Mix task:
  #
  #     mix phx.gen.cert
  #
  # Note that this task requires Erlang/OTP 20 or later.
  # Run `mix help phx.gen.cert` for more information.
  #
  # The `http:` config above can be replaced with:
  #
  #     https: [
  #       port: 4001,
  #       cipher_suite: :strong,
  #       keyfile: "priv/cert/selfsigned_key.pem",
  #       certfile: "priv/cert/selfsigned.pem"
  #     ],
  #
  # If desired, both `http:` and `https:` keys can be
  # configured to run both http and https servers on
  # different ports.

  # Watch static and templates for browser reloading.
  config :slurpee, SlurpeeWeb.Endpoint,
    live_reload: [
      patterns: [
        ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
        ~r"priv/gettext/.*(po)$",
        ~r"lib/slurpee_web/(live|views)/.*(ex)$",
        ~r"lib/slurpee_web/templates/.*(eex)$"
      ]
    ]

  # Slurp
  config :slurp,
    blockchains: %{
      "eth-mainnet" => %{
        start_on_boot: true,
        name: "Ethereum Mainnet",
        adapter: Slurp.Adapters.Evm,
        network_id: 1,
        chain_id: 1,
        chain: "ETH",
        testnet: false,
        timeout: 5000,
        new_head_initial_history: 0,
        poll_interval_ms: 2_500,
        explorer: {Slurp.ExplorerAdapters.Etherscan, "https://etherscan.io"},
        rpc: [
          "https://api.mycryptoapi.com/eth"
        ]
      },
      "bsc-mainnet" => %{
        start_on_boot: false,
        name: "Binance Smart Chain Mainnet",
        adapter: Slurp.Adapters.Evm,
        network_id: 56,
        chain_id: 56,
        chain: "BSC",
        testnet: false,
        new_head_initial_history: 0,
        poll_interval_ms: 1_000,
        explorer: {Slurp.ExplorerAdapters.BscScan, "https://bscscan.com"},
        rpc: [
          "https://bsc-dataseed1.binance.org"
        ]
      },
      "matic-mainnet" => %{
        start_on_boot: false,
        name: "Matic Mainnet",
        adapter: Slurp.Adapters.Evm,
        network_id: 137,
        chain_id: 137,
        chain: "Matic",
        testnet: false,
        timeout: 5000,
        new_head_initial_history: 0,
        poll_interval_ms: 2_500,
        explorer: {Slurp.ExplorerAdapters.Polygonscan, "https://polygonscan.com"},
        rpc: [
          "https://rpc-mainnet.matic.network"
        ]
      },
      "avalanche-mainnet" => %{
        start_on_boot: false,
        name: "Avalanche Mainnet",
        adapter: Slurp.Adapters.Evm,
        network_id: 43114,
        chain_id: 43114,
        chain: "Avax",
        testnet: false,
        timeout: 5000,
        new_head_initial_history: 0,
        poll_interval_ms: 2_500,
        explorer: {Slurp.ExplorerAdapters.Avascan, "https://avascan.info"},
        rpc: [
          "https://api.avax.network/ext/bc/C/rpc"
        ]
      }
    }

  config :slurp,
    new_head_subscriptions: %{
      "*" => [
        %{
          enabled: true,
          handler: {Slurpee.NewHeadHandler, :handle_new_head, []}
        }
      ]
    }

  config :slurp,
    log_subscriptions: %{
      "*" => %{
        # ERC20
        "Approval(address,address,uint256)" => [
          %{
            enabled: true,
            struct: Examples.Erc20.Events.Approval,
            handler: {Slurpee.EventHandler, :handle_event, []},
            abi: [
              %{
                "anonymous" => false,
                "inputs" => [
                  %{
                    "indexed" => true,
                    "name" => "owner",
                    "type" => "address"
                  },
                  %{
                    "indexed" => true,
                    "name" => "spender",
                    "type" => "address"
                  },
                  %{
                    "indexed" => false,
                    "name" => "value",
                    "type" => "uint256"
                  }
                ],
                "name" => "Approval",
                "type" => "event"
              }
            ]
          }
        ]
      }
    }
end

if config_env() == :test do
  # We don't run a server during test. If one is required,
  # you can enable the server option below.
  config :slurpee, SlurpeeWeb.Endpoint,
    http: [port: 4002],
    server: false

  # Print only warnings and errors during test
  config :logger, level: :warn
end
