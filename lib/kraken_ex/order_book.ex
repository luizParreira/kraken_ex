defmodule KrakenEx.OrderBook do

  @moduledoc  """
  This module gets the order book data from Kraken's public API.
  """

  @doc """
  Gets order book data based on:
    pair: asset pair to get market depth for
    count: maximum number of asks/bids (optional)

  returns
    Success: `{:ok, order_book}`.
    Fail:    `{:error, errors}`

  # Examples

    iex> KrakenEx.order_book(pair: "XXLMXXBT")
    iex> KrakenEx.order_book(pair: "XXLMXXBT", count: 100)
    %{"XXRPZUSD" => %{"asks" => [["0.30905800", "4.677", 1498006436],
     ["0.30905900", "4.594", 1498006428], ["0.30906000", "14.253", 1498006422],
     ["0.30906100", "4.583", 1498006414], ["0.30906200", "4.694", 1498006404],
     ["0.30906300", "17.650", 1498006396], ["0.30906500", "7.869", 1498006417],
    "bids" => [["0.30900100", "133.668", 1498006440],
     ["0.30900000", "9317.601", 1498006434],
     ["0.30625400", "1191.349", 1498006433],
     ["0.30625300", "11.867", 1498006427], ["0.30617800", "14.939", 1498006422],
     ["0.30617700", "8.469", 1498006379], ["0.30617500", "28.101", 1498006433],
               ....
     ["0.29898200", "106.235", ...], ["0.29874300", ...], [...], ...]}}

  # More info
   You can find more info on Kraken's own [documentation](https://www.kraken.com/help/api#get-order-book).
  """

  alias KrakenEx.{
    PublicClient,
    PairRequiredParamError
  }

  @method "Depth"

  def order_book(pair, count \\ []) do
    @method
    |> compose_url(pair[:pair], count[:count])
    |> PublicClient.get
    |> parse_response
  end

  defp compose_url(method, nil, _), do: raise PairRequiredParamError
  defp compose_url(method, pair, count), do: "#{method}?pair=#{pair}&count=#{count}"
  defp compose_url(method, pair, nil), do: "#{method}?pair=#{pair}"

  defp parse_response({:ok, response}), do: parse_body(response.body)
  defp parse_response(other_response), do: other_response
  defp parse_body(%{"error" => [], "result" => result}) do
    {:ok, result}
  end

  defp parse_body(%{"error" => errors}) do
    {:error, errors}
  end
end
