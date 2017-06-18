defmodule KrakenEx.Assets do
  alias KrakenEx.PublicClient

  def assets(method \\ "Assets") do
    method
    |> PublicClient.get
    |> _parse_response
  end

  defp _parse_response({:ok, response}), do: _parse_body(response.body)
  defp _parse_response(other_response), do: other_response

  defp _parse_body(%{"error" => [], "result" => result}), do: {:ok, result}
  defp _parse_body(%{"error" => errors}) do
    {:error, errors}
  end
end
