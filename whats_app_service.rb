require 'rest-client'
require 'json'
require 'dotenv/load'

class WhatsAppService
  attr_accessor :access_token, :phone_number_id

  def initialize
    @access_token = ENV['ACCESS_TOKEN']
    @phone_number_id = ENV['PHONE_NUMBER_ID']
  end

  def send_message(to, message_body)
    url = "https://graph.facebook.com/v13.0/#{@phone_number_id}/messages"

    message = {
      messaging_product: 'whatsapp',
      to: to,
      type: 'text',
      text: {
        body: message_body
      }
    }.to_json

    begin
      response = RestClient.post(url, message, { Authorization: "Bearer #{@access_token}", content_type: :json, accept: :json })
      puts response.body
    rescue RestClient::ExceptionWithResponse => e
      puts e.response
    end
  end
end