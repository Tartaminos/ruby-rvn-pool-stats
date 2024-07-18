require 'rest-client'
require 'json'
require 'dotenv/load'

class TelegramService
  attr_accessor :bot_token, :chat_id

  def initialize
    @bot_token = ENV['TELEGRAM_BOT_TOKEN']
    @chat_id = ENV['TELEGRAM_CHAT_ID']
  end

  def send_message(message_body)
    url = "https://api.telegram.org/bot#{@bot_token}/sendMessage"

    message = {
        chat_id: @chat_id.to_i,
        text: message_body
    }.to_json

    begin
      response = RestClient.post(url, message, { content_type: :json, accept: :json })
    rescue RestClient::ExceptionWithResponse => e
        puts e.response
        File.open("telegram_service_response_error_log.txt", 'a') do |file|
            file.puts("Data: #{Time.now} - #{e.response}")
        end
    end
  end
end