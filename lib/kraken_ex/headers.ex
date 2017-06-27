defmodule KrakenEx.Headers do
  def header(signature) do
    ["API-Key": KrakenEx.api_key, "API-Sign": signature]
  end
end
