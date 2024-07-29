require 'dotenv/load'
require 'fileutils'

require_relative '../Services/telegram_service'

class RavenCoin
    attr_accessor :telegram_service, :seconds_range

    def initialize
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

    def check(data)

        hashrate = get_hashrate(data)
        difficulty = get_difficulty(data)
        avgBlockTime = get_avgBlockTime(data)

        #debug only
        #puts "\n ----- RAVEN COIN -----  #{Time.now.strftime("%d/%m/%Y %H:%M:%S")} - O hashrate está em #{hashrate} TH/s \na dificuldade está em #{difficulty} \no tempo médio por bloco é #{avgBlockTime} segundos. \nPróxima verificação em 5min"

        File.open("raven_hashrate_log_#{month_name}.txt", 'a') do |file|
            file.puts("Data: #{format_time_br(Time.now)} - Hashrate: #{hashrate} TH/s - Difficulty: #{difficulty} - Average Block Time: #{avgBlockTime} segundos")
        end

        if hashrate < 5.0 || (difficulty < 72 && @seconds_range.include?(avgBlockTime))
            message = "\u{1F6A8} \u{1F44D} \u{1F680} Alert!! \u{1F680} \u{1F44D} \u{1F6A8}
            \n \u{1F7E6} \u{1F7E7} ----- RAVEN COIN ----- \u{1F7E6} \u{1F7E7}
            \n- Hashrate: #{hashrate} TH/s 
            \n- Difficulty: #{difficulty}K
            \n- Average Block time: #{avgBlockTime}s"
            send_alert(message)

        elsif hashrate > 6.0 && difficulty > 78
            message = "\u{1F6A8} \u{1F44E} Alert!! \u{1F44E} \u{1F6A8}
            \n \u{1F7E5} ----- RAVEN COIN ----- \u{1F7E5}
            \n- Hashrate: #{hashrate} TH/s 
            \n- Difficulty: #{difficulty}K
            \n- Average Block time: #{avgBlockTime}s"
            send_alert(message)  
        end
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
end