defmodule KrakenEx.Headers do
  def header(signature) do
    ["API-Key": KrakenEx.api_key, "API-Sign": signature, "Content-Type": "application/x-www-form-urlencoded"]
  end
end
