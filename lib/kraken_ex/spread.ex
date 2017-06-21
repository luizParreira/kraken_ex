defmodule KrakenEx.Spread do
  @moduledoc  """
  This module gets the recent `Spread` data from Kraken's public API.
  """

  @doc """
  Gets recent spread data based on:
    pair: asset pair to get spread data for
    since: return trade data since given id (optional.  exclusive)

  returns
    Success: `{:ok, spread_data}`.
    Fail:    `{:error, errors}`

  # Examples

    iex> KrakenEx.spread(pair: "XXLMXXBT")
    iex> KrakenEx.spread(pair: "XXLMXXBT", since: 121343244)
    %{"XXLMXXBT" => [[1498004723, "0.000015380", "0.000015380"],
                     [1498004723, "0.000015380", "0.000015390"],
                     [1498004724, "0.000015300", "0.000015390"],
                     [1498004754, "0.000015300", "0.000015410"],
                     [1498005418, "0.000015290", "0.000015430"],
                     ...
                     [1498005426, "0.000015290", ...],
                     [1498005430, ...], [...], ...],
      "last" => 1498007924}

  # More info
   You can find more info on Kraken's own [documentation](https://www.kraken.com/help/api#get-recent-spread-data).
  """

  alias KrakenEx.{
    PublicClient,
    PairRequiredParamError
  }

  @method "Spread"

  def spread(pair, since \\ []) do
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
