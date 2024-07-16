require 'net/http'
require 'json'

class NetworkService
  def get_network_hashrate
    url = URI("https://rvn.2miners.com/api/stats")
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(url)

    response = http.request(request)

    if response.is_a?(Net::HTTPRedirection)
      location = response['location']
      puts "Redirecionado para #{location}"
      url = URI(location)
      response = Net::HTTP.get_response(url)
    end

    if response.is_a?(Net::HTTPSuccess)
      data = JSON.parse(response.body)
      data
    else
      error = "Erro ao acessar a API: #{response.code} #{response.message}"
      puts error
      nil
    end
    rescue JSON::ParserError => e
      error = "Erro ao parsear JSON: #{e.message}"
      puts error
      nil
    rescue StandardError => e
      error = "Erro ao acessar a API: #{e.message}"
      puts error
      nil
  end
end