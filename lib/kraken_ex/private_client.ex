defmodule KrakenEx.PrivateClient do
  use HTTPoison.Base

  @api_version (Application.get_env(:kraken_ex, :api_version, System.get_env("API_VERSION")) || "0")

  @base_url "https://api.kraken.com/" <> @api_version <> "/private/"
  def process_url(url) do
    @base_url <> url
  end

  def process_response_body(body) do
    Poison.decode! body
  end

  def process_request_headers(headers) do
    IO.puts "HEADERS"
    IO.inspect headers
    headers
  end
end
