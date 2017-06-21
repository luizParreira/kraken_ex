defmodule KrakenEx.AssetPairs do
  @moduledoc  """
  This module gets recent `AssetPairs` data from Kraken's public API.
  """

  @doc """
  Gets tradeable asset pairs:
    info: info to retrieve (optional):
      info: all info (default)
      leverage: leverage info
      fees: fees schedule
      margin: margin info
    pair: comma delimited list of asset pairs to get info on (optional.  default = all)

  returns
    Success: `{:ok, asset_pairs}`.
    Fail:    `{:error, errors}`

  # Examples

    iex> KrakenEx.asset_pairs(pair: "XXLMXXBT")
    iex> KrakenEx.asset_pairs
    %{"XETHZUSD.d" => %{"aclass_base" => "currency", "aclass_quote" => "currency",
    "altname" => "ETHUSD.d", "base" => "XETH", "fee_volume_currency" => "ZUSD",
    "fees" => [[0, 0.36], [50000, 0.34], [100000, 0.32], [250000, 0.3],
               [500000, 0.28], [1000000, 0.26], [2500000, 0.24], [5000000, 0.22],
               [10000000, 0.2]], "leverage_buy" => [], "leverage_sell" => [],
    "lot" => "unit", "lot_decimals" => 8, "lot_multiplier" => 1,
    "margin_call" => 80, "margin_stop" => 40, "pair_decimals" => 5, "quote" => "ZUSD"},
      ...
    "XXBTZCAD.d" => %{...}, ...}

  # More info
   You can find more info on Kraken's own [documentation](https://www.kraken.com/help/api#get-tradable-pairs).
  """

  alias KrakenEx.PublicClient

  @asset_pairs "AssetPairs"

  def asset_pairs(opts \\ []) do
    @asset_pairs
    |> compose_url(opts[:info], opts[:pair])
    |> PublicClient.get
    |> parse_response
  end

  defp compose_url(uri, nil, nil), do: uri
  defp compose_url(uri, nil, pair) when  is_list(pair) do
    "#{uri}?pair=#{parse_pair(pair)}"
  end
  defp compose_url(uri, nil, pair), do: "#{uri}?pair=#{pair}"
  defp compose_url(uri, info, nil), do: "#{uri}?info=#{info}"
  defp compose_url(uri, info, pair) when is_list(pair) do
    "#{uri}?info=#{info}&pair=#{parse_pair(pair)}"
  end
  defp compose_url(uri, info, pair), do: "#{uri}?info=#{info}&pair=#{pair}"

  defp parse_pair(pairs), do: Enum.join(pairs, ", ")

  defp parse_response({:ok, response}), do: parse_body(response.body)
  defp parse_body(%{"error" => [], "result" => result}) do
    {:ok, result}
  end

  defp parse_body(%{"error" => errors}) do
    {:error, errors}
  end
end
