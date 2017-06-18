defmodule KrakenEx.MissingApiKeyError do
  defexception message: """
    The api_key settings is required for Kraken's private endpoints. Please include your
    Kraken api key in your application config file like so:
      config :kraken_ex, api_key: _YOUR_API_KEY_
    You can also set the secret key as an environment variable:
      KRAKEN_API_KEY= _YOUR_API_KEY_
  """
end
