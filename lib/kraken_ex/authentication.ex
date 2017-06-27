defmodule KrakenEx.Authentication do
  use Bitwise
  @api_version (Application.get_env(:kraken_ex, :api_version, System.get_env("API_VERSION")) || "0")

  @base_path "/" <> @api_version <> "/private/"

  def generate_signature(method, params) do
    key = KrakenEx.private_key |> Base.decode64!(case: :lower)
    message = generate_message(method, params, nonce)
    IO.puts "Message"
    IO.puts message
    :sha512 |> :crypto.hmac(key, message) |> Base.encode64(case: :lower)
  end

  # Generate a 64-bit nonce where the 48 high bits come directly from the current
  # timestamp and the low 16 bits are pseudorandom. We can't use a pure [P]RNG here
  # because the Kraken API requires every request within a given session to use a
  # monotonically increasing nonce value. This approach splits the difference.
  # Nonce implementation based on:
  # https://github.com/leishman/kraken_ruby/blob/master/lib/kraken_ruby/client.rb#L150
  defp nonce do
    DateTime.to_unix(DateTime.utc_now, :millisecond) <<< 10 |> Integer.to_string
  end

  defp generate_message(method, params, input_nonce) do
    digest = :crypto.hash_init(:sha256)
          |> :crypto.hash_update(input_nonce <> params)
          |> :crypto.hash_final
          |> Base.encode16(case: :lower)

    IO.puts "DIGEST"
    IO.puts digest
    @base_path <> method <> digest
  end
end
