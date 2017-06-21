defmodule KrakenEx.SpreadTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias KrakenEx.{
    PublicClient,
    PairRequiredParamError
  }

  setup_all do
    PublicClient.start
  end

  test "get spread data without a `pair:` keyword" do
    since = "12342312"
    assert_raise PairRequiredParamError, fn ->
      KrakenEx.spread(since: since)
    end
  end

  test "get spread for given asset pair" do
    use_cassette "get_spread_for_pair" do
      asset_pair = "XXRPZUSD"
      {:ok, spread} = KrakenEx.spread(pair: asset_pair)
      assert Map.keys(spread) == [asset_pair, "last"]
    end
  end
end
