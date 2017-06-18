defmodule KrakenEx.MissingPrivateKeyError do
  defexception message: """
    The private_key settings is required for Kraken's private endpoints. Please include your
    Kraken private key in your application config file like so:
      config :kraken_ex, private_key: _YOUR_PRIVATE_KEY_
    You can also set the secret key as an environment variable:
      KRAKEN_PRIVATE_KEY= _YOUR_PRIVATE_KEY_
  """
end
