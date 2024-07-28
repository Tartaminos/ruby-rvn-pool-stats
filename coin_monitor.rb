require 'bundler/setup'
require 'dotenv/load'

require_relative 'Services/network_service'
require_relative 'Coins/raven_coin'
require_relative 'Coins/btc_cash'

class CoinMonitor
  attr_accessor :network_service, :telegram_service, :raven_coin, :btc_cash

  def initialize
    @network_service = NetworkService.new
    @raven_coin = RavenCoin.new
    @bitcoin_cash = BtcCash.new
  end

  def raven_coin_check

    raven_data = @network_service.get_network_data("raven")

    @raven_coin.check(raven_data)

  end

  def btc_cash_check

    btc_cash_data = @network_service.get_network_data("btc_cash")

    @bitcoin_cash.check(btc_cash_data)

  end

  def monitor_network
    loop do 

      raven_coin_check()

      sleep 1

      btc_cash_check()

      sleep 300

    end

  end
end

monitor = CoinMonitor.new

monitor.monitor_network