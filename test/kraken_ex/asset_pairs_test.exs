defmodule KrakenEx.AssetPairsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias KrakenEx.PublicClient

  setup_all do
    PublicClient.start
  end

  test "get AssetPairs available" do
    use_cassette "get_asset_pairs" do
      {:ok, asset_pairs} = KrakenEx.asset_pairs
      asset_pairs_names = Map.keys(asset_pairs)
      assert Enum.count(asset_pairs_names) == 60
    end
  end

  test "get AssetPairs based on given pair" do
    use_cassette "get_asset_pairs_filtered" do
      {:ok, asset_pairs} = KrakenEx.asset_pairs(
        pairs: ~w(XXBTZJPY XZECZUSD XETCZUSD XREPXETH),
        info: :leverage
      )
      asset_pairs_names = Map.keys(asset_pairs)
      assert Enum.count(asset_pairs_names) == 4
    end
  end
end
