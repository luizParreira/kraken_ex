defmodule KrakenEx.AssetPairs do
  alias KrakenEx.PublicClient
  @asset_pairs "AssetPairs"
  def asset_pairs(opts \\ []) do
    @asset_pairs
    |> compose_url(opts[:info], opts[:pairs])
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
