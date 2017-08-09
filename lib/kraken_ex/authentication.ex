defmodule KrakenEx.Authentication do
  use Bitwise
  @api_version (Application.get_env(:kraken_ex, :api_version, System.get_env("API_VERSION")) || "0")

  @base_path "/" <> @api_version <> "/private/"

  # Authentication with kraken happens the following way:
  #
  #   1. Get the SHA256(nonce + POST data)
  #   2. Get the URI path
  #   3. HMAC-SHA512 (2. + 1.) and base64 decoded secret key API key
  #

  def generate_signature(method, params) do
    key = KrakenEx.private_key |> Base.decode64!
    message = generate_message(method, params)
    IO.puts "Message"
    IO.inspect message
    :sha512 |> :crypto.hmac(key, message) |> Base.encode64
  end

  # Generate a 64-bit nonce where the 48 high bits come directly from the current
  # timestamp and the low 16 bits are pseudorandom. We can't use a pure [P]RNG here
  # because the Kraken API requires every request within a given session to use a
  # monotonically increasing nonce value. This approach splits the difference.
  # Nonce implementation based on:
  # https://github.com/leishman/kraken_ruby/blob/master/lib/kraken_ruby/client.rb#L150

  defp generate_message(method, params) do
    post_data = params |> URI.encode_query
    digest = :crypto.hash(:sha256, params.nonce <> post_data)
    uri = @base_path <> method
    uri <> digest
  end
end
