# encoding: UTF-8
# frozen_string_literal: true

module WalletClient
  class Litecoind < Bitcoind
    def create_address!(options = {})
      { address: normalize_address(json_rpc(:getnewaddress, ['', 'legacy']).fetch('result')) }
    end
  end
end
