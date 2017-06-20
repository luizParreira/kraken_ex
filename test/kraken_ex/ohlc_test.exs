defmodule KrakenEx.OHLCTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias KrakenEx.{
    PublicClient,
    PairRequiredParamError
  }

  setup_all do
    PublicClient.start
  end

  test "get OHLC given asset pair" do
    use_cassette "get_ohlc" do
      asset_pair = "XXRPZUSD"
      {:ok, ohlc_data} = KrakenEx.ohlc(pair: asset_pair)
      assert Map.keys(ohlc_data) == [asset_pair, "last"]
    end
  end

  test "get OHLC given asset pair and interval" do
    use_cassette "get_ohlc_with_interval" do
      asset_pair = "XXRPZUSD"
      interval = 5
      {:ok, ohlc_data} = KrakenEx.ohlc(pair: asset_pair, interval: interval)
      assert Map.keys(ohlc_data) == [asset_pair, "last"]
    end
  end

  test "get OHLC data without a `pair:` keyword" do
    interval = 5
    assert_raise PairRequiredParamError, fn ->
      KrakenEx.ohlc(interval: interval)
    end
  end
end
