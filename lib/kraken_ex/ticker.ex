defmodule KrakenEx.Ticker do
  alias KrakenEx.PublicClient

  @method "Ticker"

  def ticker(opts) do
    @method
    |> compose_url(opts[:pairs])
    |> PublicClient.get
    |> parse_response
  end

  defp compose_url(method, pairs) when is_list(pairs) do
    "#{method}?pair=#{Enum.join(pairs, ", ")}"
  end
  defp compose_url(method, pairs), do: "#{method}?pair=#{pairs}"

  defp parse_response({:ok, response}), do: parse_body(response.body)
  defp parse_body(%{"error" => [], "result" => result}) do
    {:ok, result}
  end

  defp parse_body(%{"error" => errors}) do
    {:error, errors}
  end
end
