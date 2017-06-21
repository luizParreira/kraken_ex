defmodule KrakenEx.OrderBookTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias KrakenEx.{
    PublicClient,
    PairRequiredParamError
  }

  setup_all do
    PublicClient.start
  end

  test "get order book data without a `pair:` keyword" do
    count = 10
    assert_raise PairRequiredParamError, fn ->
      KrakenEx.order_book(count: count)
    end
  end

  test "get order book for given asset pair" do
    use_cassette "get_order_book_for_pair" do
      asset_pair = "XXRPZUSD"
      {:ok, order_book} = KrakenEx.order_book(pair: asset_pair)
      response = Map.keys(order_book[asset_pair])
      assert response == ["asks", "bids"]
      assert Enum.count(order_book[asset_pair]["bids"]) == 100
      assert Enum.count(order_book[asset_pair]["asks"]) == 100
    end
  end
end
