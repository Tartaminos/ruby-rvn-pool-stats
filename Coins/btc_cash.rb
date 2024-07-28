require 'dotenv/load'

require_relative '../Services/telegram_service'

class BtcCash
    attr_accessor :telegram_service, :seconds_range

    def initialize
        @telegram_service = TelegramService.new
        @seconds_range = [7, 8, 9]
    end

    def get_hashrate(data)
        hashrate = data['nodes'][0]['networkhashps'].to_f / 1_000_000_000_000_000_000.0 
        hashrate.round(2)
    end
    
    def get_difficulty(data)
        difficulty = data['nodes'][0]['difficulty'].to_f / 10**9
        difficulty.round(2)
    end
    
    def get_avgBlockTime(data)
        avgBlockTime = data['nodes'][0]['avgBlockTime'].to_f / 60
        avgBlockTime.round()
    end

    def check(data)

        hashrate = get_hashrate(data)
        difficulty = get_difficulty(data)
        avgBlockTime = get_avgBlockTime(data)

        #debug only
        #puts " \n ----- BITCOIN CASH ----- #{Time.now.strftime("%d/%m/%Y %H:%M:%S")} - O hashrate está em #{hashrate} EH/s \na dificuldade está em #{difficulty}G \no tempo médio por bloco é #{avgBlockTime} minutos. \nPróxima verificação em 5min"

        File.open("logs/btc_cash_hashrate_log_#{month_name}.txt", 'a') do |file|
            file.puts("Data: #{format_time_br(Time.now)} - Hashrate: #{hashrate} EH/s - Difficulty: #{difficulty} - Average Block Time: #{avgBlockTime} segundos")
        end

       if hashrate < 3.5 || (difficulty < 450 && @seconds_range.include?(avgBlockTime))
           message = "\u{1F6A8} \u{1F44D} \u{1F680} Alert!! \u{1F680} \u{1F44D} \u{1F6A8}
           \n \u{1F7E9} \u{1F7E9} ----- BITCOIN CASH ----- \u{1F7E9} \u{1F7E9}
           \n- Hashrate: #{hashrate} EH/s 
           \n- Difficulty: #{difficulty}G
           \n- Average Block time: #{avgBlockTime} minutes"
           send_alert(message)
           puts message

       elsif hashrate > 4.0 && difficulty > 460
           message = "\u{1F6A8} \u{1F44E} Alert!! \u{1F44E} \u{1F6A8}
           \n \u{1F7E5} ----- BITCOIN CASH ----- \u{1F7E5}
           \n- Hashrate: #{hashrate} EH/s 
           \n- Difficulty: #{difficulty}G
           \n- Average Block time: #{avgBlockTime} minutes"
           send_alert(message)
           puts message       
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