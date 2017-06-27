defmodule KrakenEx do
  alias KrakenEx.{
    MissingApiKeyError,
    MissingPrivateKeyError
  }

  @doc false
  def api_key do
    Application.get_env(:kraken_ex, :api_key, System.get_env("KRAKEN_API_KEY"))
    || raise MissingApiKeyError
  end

  @doc false
  def private_key do
    Application.get_env(:kraken_ex, :private_key, System.get_env("KRAKEN_PRIVATE_KEY"))
    || raise MissingPrivateKeyError
  end

  # Public Methods:
  defdelegate server_time, to: KrakenEx.ServerTime
  defdelegate assets, to: KrakenEx.Assets
  defdelegate assets(assets), to: KrakenEx.Assets
  defdelegate asset_pairs, to: KrakenEx.AssetPairs
  defdelegate asset_pairs(options), to: KrakenEx.AssetPairs
  defdelegate ohlc(pair, opts), to: KrakenEx.OHLC
  defdelegate ohlc(pair), to: KrakenEx.OHLC
  defdelegate ticker(opts), to: KrakenEx.Ticker
  defdelegate order_book(pair, count), to: KrakenEx.OrderBook
  defdelegate order_book(pair), to: KrakenEx.OrderBook
  defdelegate trades(pair, since), to: KrakenEx.Trades
  defdelegate trades(pair), to: KrakenEx.Trades
  defdelegate spread(pair, since), to: KrakenEx.Spread
  defdelegate spread(pair), to: KrakenEx.Spread

  # Private Methods:
  defdelegate balance, to: KrakenEx.Balance
end
