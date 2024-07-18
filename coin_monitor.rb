require 'bundler/setup'
require 'dotenv/load'

require_relative 'telegram_service'
require_relative 'network_service'

class CoinMonitor
  attr_accessor :network_service, :whatsapp_service, :telegram_service, :phone_number

  def initialize
    @phone_number = ENV['SEND_TO_PHONE_NUMBER']
    @network_service = NetworkService.new
    @telegram_service = TelegramService.new
  end

  def get_hashrate(data)
    hashrate = data['nodes'][0]['networkhashps'].to_f / 1_000_000_000_000.0 
    hashrate.round(2)
  end

  def get_difficulty(data)
    difficulty = data['nodes'][0]['difficulty'].to_f / 10**3 
    difficulty.round(2)
  end

  def get_avgBlockTime(data)
    avgBlockTime = data['nodes'][0]['avgBlockTime'].to_f
  end

  def send_alert(message)
    @telegram_service.send_message(message)
  end

  def format_time_br(time)
    time.strftime("%d/%m/%Y %H:%M:%S")
  end

  def month_name
    today = Date.today
    first_day = Date.new(today.year, today.month, 1)
    first_day.strftime("%B")
  end

  def monitor_network
    loop do
      data = @network_service.get_network_data
      next unless data

      hashrate = get_hashrate(data)
      difficulty = get_difficulty(data)
      avgBlockTime = get_avgBlockTime(data)

      File.open("hashrate_log_#{month_name}.txt", 'a') do |file|
        file.puts("Data: #{format_time_br(Time.now)} - Hashrate: #{hashrate} TH/s - Difficulty: #{difficulty} - Average Block Time: #{avgBlockTime} segundos")
      end

      if hashrate < 5.0 || (difficulty < 72 && avgBlockTime <= 58)
        message = "\u{1F6A8} \u{1F44D} \u{1F680} Alerta!! \u{1F680} \u{1F44D} \u{1F6A8}
        \n- Hashrate da rede: #{hashrate} TH/s 
        \n- Difficulty: #{difficulty}K
        \n- Tempo médio por bloco: #{avgBlockTime} segundos
        \n\u26CF \u26CF Bom para mineração! \u26CF \u26CF "
        send_alert(message)
        puts message

      elsif hashrate > 6.0 && difficulty > 78
        message = "\u{1F6A8} \u{1F44E} Alerta!! \u{1F44E} \u{1F6A8}
        \n- Hashrate da rede: #{hashrate} TH/s 
        \n- Difficulty: #{difficulty}K
        \n- Tempo médio por bloco: #{avgBlockTime} segundos 
        \n\u{1F44E} Não indicado para mineração \u{1F44E}"
        send_alert(message)
        puts message       
      end
      #debug only
      #puts "#{format_time_br(Time.now)} - O hashrate da rede está em #{hashrate} TH/s \na dificuldade está em #{difficulty} \no tempo médio por bloco é #{avgBlockTime} segundos. \nPróxima verificação em 5min: #{format_time_br(Time.now + 300)}"

      sleep 300 
    end
  end
end

monitor = CoinMonitor.new

monitor.monitor_network