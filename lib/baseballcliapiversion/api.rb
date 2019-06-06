class Baseballcliapiversion::Api
    def self.send_request
        uri = URI("https://api.mysportsfeeds.com/v1.2/pull/mlb/2019-regular/daily_game_schedule.json?fordate=20190406")
      
        # Create client
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_PEER
      
        # Create Request
        req =  Net::HTTP::Get.new(uri)
        # Add headers
        req.basic_auth("#{ENV[Sportsfeed_key]}", "#{ENV[Sportsfeed_pw]}")
        # Fetch Request
        res = http.request(req).body
      end
    
end