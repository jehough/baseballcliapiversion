class Baseballcliapiversion::Api

  def self.get_games
    d = Time.now - 86400
    date = d.strftime('%Y%m%d')
    path = "https://api.mysportsfeeds.com/v1.2/pull/mlb/2019-regular/scoreboard.xml?fordate=#{date}"
    send_request(path)
  end

  def self.game_ids
    games = get_games
    games_array = games.xpath('scor:scoreboard').xpath('scor:gameScore').collect do |game|
      game.xpath('scor:game').xpath('scor:ID').text
    end
  end

  def self.get_boxes
    boxes_hash = game_ids.collect do |game|
      path = "https://api.mysportsfeeds.com/v1.2/pull/mlb/current/game_boxscore.xml?gameid=#{game}"
      noko = send_request(path)
      game_hash(noko)
    end
  end

  def self.game_hash(noko)
    game = noko.xpath('gam:gameboxscore')
    hash = {
      :id => game.xpath('gam:game').xpath('gam:id').text,
      :away_team => game.xpath('gam:game').xpath('gam:awayTeam').xpath('gam:Name').text,
      :home_team => game.xpath('gam:game').xpath('gam:homeTeam').xpath('gam:Name').text,
      :away_innings => [],
      :home_innings => [],

    }
    game.xpath('gam:inningSummary').xpath('gam:inning').each do |inning|
      hash[:away_innings] << inning.xpath('gam:awayScore').text.to_i
      hash[:home_innings] << inning.xpath('gam:homeScore').text.to_i
    end
    hash
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
    req.basic_auth("#{ENV[Sportsfeed_key]}", "#{ENV[Sportsfeed_pw]}")

    # Fetch Request
    res = http.request(req).body
    Nokogiri::XML(res)
    
  end

end