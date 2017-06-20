defmodule KrakenEx.Assets do
  alias KrakenEx.PublicClient

  def assets(method \\ "Assets") do
    method
    |> PublicClient.get
    |> parse_response
  end

  defp parse_response({:ok, response}), do: parse_body(response.body)
  defp parse_response(other_response), do: other_response

  defp parse_body(%{"error" => [], "result" => result}), do: {:ok, result}
  defp parse_body(%{"error" => errors}) do
    {:error, errors}
  end
end
