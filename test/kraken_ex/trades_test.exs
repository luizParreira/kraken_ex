defmodule KrakenEx.TradesTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias KrakenEx.{
    PublicClient,
    PairRequiredParamError
  }

  setup_all do
    PublicClient.start
  end

  test "get trades data without a `pair:` keyword" do
    since = "12342312"
    assert_raise PairRequiredParamError, fn ->
      KrakenEx.trades(since: since)
    end
  end

  test "get trades for given asset pair" do
    use_cassette "get_trades_for_pair" do
      asset_pair = "XXRPZUSD"
      {:ok, trades} = KrakenEx.trades(pair: asset_pair)
      assert Map.keys(trades) == [asset_pair, "last"]
    end
  end
end
