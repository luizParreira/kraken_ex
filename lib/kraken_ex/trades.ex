defmodule KrakenEx.Trades do
  @moduledoc  """
  This module gets recent `Trades` data from Kraken's public API.
  """

  @doc """
  Gets recent trades data based on:
    pair: asset pair to get trade data for
    since: return trade data since given id (optional.  exclusive)

  returns
    Success: `{:ok, trades_data}`.
    Fail:    `{:error, errors}`

  # Examples

    iex> KrakenEx.trades(pair: "XXLMXXBT")
    iex> KrakenEx.trades(pair: "XXLMXXBT", since: 121343244)
    %{"XXLMXXBT" => [["0.000016560", "11876.21035730", 1497967563.678, "b", "m",""],
                     ["0.000016570", "135.68710500", 1497967563.6897, "b", "m", ""],
                     ["0.000016590", "417.13200000", 1497967563.6998, "b", "m", ""],
                     ["0.000016590", "45.23481086", 1497967563.7041, "b", "m", ""],
                     ...
                     ["0.000016150", "362.66198327", ...], ["0.000016140", ...], [...], ...],
      "last" => "1498007298159049546"}

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
