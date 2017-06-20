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
end
