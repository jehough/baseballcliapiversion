class Baseballcliapiversion::Api

  def self.get_games
    d = Time.now - 86400
    date = d.strftime('%Y%m%d')
    path = "https://api.mysportsfeeds.com/v1.2/pull/mlb/2019-regular/scoreboard.xml?fordate=#{date}"
    send_request(path)
  end

  def self.game_hash
    games = get_games
    games_array = games.xpath('scor:scoreboard').xpath('scor:gameScore').collect do |game|
      {:id => game.xpath('scor:game').xpath('scor:ID').text,
      :away_team => game.xpath('scor:game').xpath('scor:awayTeam').xpath('scor:Name').text,
      :home_team => game.xpath('scor:game').xpath('scor:homeTeam').xpath('scor:Name').text,
      :home_final => game.xpath('scor:homeScore').text,
      :away_final => game.xpath('scor:awayScore').text,
      }
    end
  end

  def self.get_box
    game_hash.each do |game|
      game_id = game[:id]
      path = "https://api.mysportsfeeds.com/v1.2/pull/mlb/current/game_boxscore.xml?gameid=#{game_id}"
      noko = send_request(path)
    end
  end

  def self.send_request(path)

    uri = URI(path)

    # Create client
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER

    # Create Request
    req =  Net::HTTP::Get.new(uri)
    # Add headers
    req.basic_auth("b99e7738-3a77-40ef-8dca-a7f62d", "Gc2kw3hcRVreqWy")

    # Fetch Request
    res = http.request(req).body
    Nokogiri::XML(res)
    
  end

end