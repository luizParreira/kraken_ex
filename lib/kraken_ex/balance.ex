defmodule KrakenEx.Balance do

  alias KrakenEx.{Headers, PrivateClient, Authentication}

  @method "Balance"

  def balance do
    signature = Authentication.generate_signature(@method, "")
    headers = Headers.header(signature)

    @method
    |> PrivateClient.get(headers)
    |> parse_response
  end

  defp parse_response({:ok, response}), do: parse_body(response.body)
  defp parse_response(other_response), do: other_response
  defp parse_body(%{"error" => [], "result" => result}) do
    {:ok, result}
  end

  defp parse_body(%{"error" => errors}) do
    {:error, errors}
  end
end
