defmodule KrakenEx.Balance do

  alias KrakenEx.{Headers, PrivateClient, Authentication}

  @method "Balance"

  def balance(params \\ %{}) do
    params = Map.put(params, :nonce, nonce)
    signature = Authentication.generate_signature(@method, params)
    headers = Headers.header(signature)

    @method
    |> compose_url(params)
    |> PrivateClient.get(headers)
    |> parse_response
  end

  defp compose_url(method, %{nonce: req_nonce}), do: "#{method}?nonce=#{req_nonce}"

  defp parse_response({:ok, response}), do: parse_body(response.body)
  defp parse_response(other_response), do: other_response
  defp parse_body(%{"error" => [], "result" => result}) do
    {:ok, result}
  end

  defp parse_body(%{"error" => errors}) do
    {:error, errors}
  end

  defp nonce do
    timestamp = DateTime.utc_now
    |> DateTime.to_unix(:millisecond)
    |> Integer.to_string

    timestamp <> "0"
  end
end
