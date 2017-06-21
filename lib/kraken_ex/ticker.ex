defmodule KrakenEx.Ticker do
  @moduledoc  """
  This module gets the recent `Ticker` data for given pairs Kraken's public API.
  """

  @doc """
  Gets recent ticker info for asset pair:
    pair: comma delimited list of asset pairs to get info on

  returns
    Success: `{:ok, ticker_data}`.
    Fail:    `{:error, errors}`

  # Examples

    iex> KrakenEx.ticker(pair: ["XXLMXXBT", "XXLMXXBT"])
    iex> KrakenEx.ticker(pair: "XXLMXXBT")
    %{"XXLMXXBT" => %{"a" => ["0.000015440", "10660", "10660.000"],
      "b" => ["0.000015300", "75685", "75685.000"],
      "c" => ["0.000015300", "926.27378900"],
      "h" => ["0.000015460", "0.000017270"],
      "l" => ["0.000015020", "0.000014280"], "o" => "0.000015300",
      "p" => ["0.000015294", "0.000016078"], "t" => [57, 2776],
      "v" => ["205632.66860317", "25720856.09371803"]}}

  # More info
   You can find more info on Kraken's own [documentation](https://www.kraken.com/help/api#get-ticker-info).
  """

  alias KrakenEx.{
    PublicClient,
    PairRequiredParamError
  }

  @method "Ticker"

  def ticker(opts) do
    @method
    |> compose_url(opts[:pair])
    |> PublicClient.get
    |> parse_response
  end

  defp compose_url(method, nil), do: raise PairRequiredParamError
  defp compose_url(method, pairs) when is_list(pairs) do
    "#{method}?pair=#{Enum.join(pairs, ", ")}"
  end
  defp compose_url(method, pairs), do: "#{method}?pair=#{pairs}"

  defp parse_response({:ok, response}), do: parse_body(response.body)
  defp parse_response(response), do: response

  defp parse_body(%{"error" => [], "result" => result}) do
    {:ok, result}
  end
  defp parse_body(%{"error" => errors}) do
    {:error, errors}
  end
end
