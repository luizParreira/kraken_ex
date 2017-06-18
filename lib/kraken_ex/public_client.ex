defmodule KrakenEx.PublicClient do
  use HTTPoison.Base
  @api_version (Application.get_env(:kraken_ex, :api_version, System.get_env("API_VERSION")) || "0")

  def process_url(url) do
    "https://api.kraken.com/" <> @api_version <> "/public/" <> url
  end

  def process_response_body(body) do
    Poison.decode! body
  end
end
