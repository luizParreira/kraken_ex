defmodule KrakenEx.TickerTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias KrakenEx.{
    PublicClient,
    PairRequiredParamError
  }

  setup_all do
    PublicClient.start
  end

  @pairs ~w(XXBTZJPY XZECZUSD XETCZUSD XREPXETH)

  test "get Tickers for given pairs available" do
    use_cassette "get_ticker_based_on_pairs" do
      {:ok, asset_pairs} = KrakenEx.ticker(pair: @pairs)
      asset_pairs_names = Map.keys(asset_pairs)
      assert Enum.sort(asset_pairs_names) == Enum.sort(@pairs)
      assert asset_pairs["XXBTZJPY"] |> Map.keys |> Enum.sort == ~w(a b c v p t l h o) |> Enum.sort
    end
  end

  test "get ticker data without informing `pair:`" do
    assert_raise PairRequiredParamError, fn ->
      KrakenEx.ticker(inteval: 10)
    end
  end
end
