defmodule KrakenEx.AssetsTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias KrakenEx.PublicClient
  @expected_asset_names ~w(
    DASH GNO KFEE USDT XDAO XETC XETH XICN XLTC XMLN
    XNMC XREP XXBT XXDG XXLM XXMR XXRP XXVN XZEC ZCAD
    ZEUR ZGBP ZJPY ZKRW ZUSD
  )

  setup_all do
    PublicClient.start
  end

  test "get Assets available" do
    use_cassette "get_assets" do
      {:ok, assets} = KrakenEx.assets("Assets")
      asset_names = Map.keys(assets)
      assert asset_names == @expected_asset_names
    end
  end
end
