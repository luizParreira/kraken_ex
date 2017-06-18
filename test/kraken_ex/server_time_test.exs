defmodule KrakenEx.ServerTimeTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias KrakenEx.PublicClient

  setup_all do
    PublicClient.start
  end

  test "get server time" do
    use_cassette "get_server_time" do
      timestamp = 1497807620
      assert KrakenEx.server_time == DateTime.from_unix(timestamp)
    end
  end
end
