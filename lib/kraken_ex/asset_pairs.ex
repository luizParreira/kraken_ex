defmodule KrakenEx.AssetPairs do
  alias KrakenEx.PublicClient
  @asset_pairs "AssetPairs"
  def asset_pairs(opts \\ %{}) do
    @asset_pairs
    |> compose_url(opts)
    |> PublicClient.get
    |> parse_response
  end

  defp compose_url(uri, opts) do
    params = encode_params(opts)
    uri <> encode_query(params)
  end

  defp encode_query(%{}), do: ""

  defp encode_query(%{pair: pair, info: info}) do
    "?pair=#{pair}&info=#{info}"
  end

  defp encode_query(%{pair: pair}) do
    "?pair=#{pair}"
  end

  defp encode_query(%{info: info}) do
    "?info=#{info}"
  end

  defp encode_params(%{pair: pair, info: info}) do
    %{ pair: parse_pair(pair), info: info }
  end

  defp encode_params(%{pair: pair}) do
    %{ pair: parse_pair(pair) }
  end
  defp encode_params(params), do: params

  defp parse_pair(pairs), do: Enum.join(pairs, ", ")

  defp parse_response({:ok, response}), do: parse_body(response.body)
  defp parse_body(%{"error" => [], "result" => result}) do
    {:ok, result}
  end

  defp parse_body(%{"error" => errors}) do
    {:error, errors}
  end
end
