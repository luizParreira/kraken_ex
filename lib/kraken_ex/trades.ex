defmodule KrakenEx.Trades do
  @moduledoc  """
  This module gets recent `Trades` data from Kraken's public API.
  """

  @doc """
  Gets recent trades data based on:
    pair: asset pair to get trade data for
    since: return trade data since given id (optional.  exclusive)

  returns
    Success: `{:ok, ohlc_data}`.
    Fail:    `{:error, errors}`

  # Examples

    iex> KrakenEx.trades(pair: "XXLMXXBT")
    iex> KrakenEx.trades(pair: "XXLMXXBT", since: 121343244)
    %{"XXLMXXBT" => [[1497873720, "0.00001523", "0.00001523", "0.00001523",
      "0.00001523", "0.00000000", "0.00000000", 0],
      ...
      [1497877020, "0.00001517", ...], [1497877080, ...], [...], ...]]
      "last" => 1497916800}}

  # More info
   You can find more info on Kraken's own [documentation](https://www.kraken.com/help/api#get-recent-trades).
  """

  alias KrakenEx.{
    PublicClient,
    PairRequiredParamError
  }

  @method "Trades"

  def trades(pair, since \\ []) do
    @method
    |> compose_url(pair[:pair], since[:since])
    |> PublicClient.get
    |> parse_response
  end

  defp compose_url(method, nil, _), do: raise PairRequiredParamError
  defp compose_url(method, pair, nil), do: "#{method}?pair=#{pair}"
  defp compose_url(method, pair, since), do: "#{method}?pair=#{pair}&since=#{since}"

  defp parse_response({:ok, response}), do: parse_body(response.body)
  defp parse_response(other_response), do: other_response

  defp parse_body(%{"error" => [], "result" => result}), do: {:ok, result}
  defp parse_body(%{"error" => errors}) do
    {:error, errors}
  end
end
