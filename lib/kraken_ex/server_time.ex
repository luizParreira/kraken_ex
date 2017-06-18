defmodule KrakenEx.ServerTime do
  alias KrakenEx.PublicClient

  def server_time do
    case PublicClient.get("Time") do
      {:ok, response} -> _parse_body(response.body)
    end
  end

  defp _parse_body(%{"error" => [], "result" => result}) do
    DateTime.from_unix(result["unixtime"])
  end

  defp _parse_body(%{"error" => errors, "result" => result}) do
    {:error, errors}
  end
end
