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

  defdelegate server_time, to: KrakenEx.ServerTime
  defdelegate assets(assets), to: KrakenEx.Assets
end
