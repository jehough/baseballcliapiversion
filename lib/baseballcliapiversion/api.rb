
class Baseballcliapiversion::Api

  # Request (GET )
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

  def self.get_players(game_id)
      path = "https://api.mysportsfeeds.com/v1.2/pull/mlb/current/game_boxscore.xml?gameid=#{game_id}"
      noko = send_request(path)
      player_hash(noko)
  end

  def self.player_hash(noko)
    away_team = noko.xpath('gam:gameboxscore').xpath('gam:game').xpath('gam:awayTeam').xpath('gam:Name').text
    home_team = noko.xpath('gam:gameboxscore').xpath('gam:game').xpath('gam:homeTeam').xpath('gam:Name').text
    
    hash = {"#{away_team}" => [],
      "#{home_team}" => []
      }  
    
      noko.xpath('gam:gameboxscore').xpath('gam:awayTeam').xpath('gam:awayPlayers').xpath('gam:playerEntry').each do |player|
        player_stats = create_player_hash(player)
        hash["#{away_team}"] << player_stats
      end

      noko.xpath('gam:gameboxscore').xpath('gam:homeTeam').xpath('gam:homePlayers').xpath('gam:playerEntry').each do |player|
        player_stats = create_player_hash(player)
        hash["#{home_team}"] << player_stats
      end

    hash

  end

  def self.create_player_hash(player)
    player_stats = {
          :name =>  player.xpath('gam:player').xpath('gam:FirstName').text + " " + player.xpath('gam:player').xpath('gam:LastName').text,
          :at_bats => player.xpath('gam:stats').xpath('gam:AtBats').text,
          :hits => player.xpath('gam:stats').xpath('gam:Hits').text,
          :runs => player.xpath('gam:stats').xpath('gam:Runs').text,
          :rbis => player.xpath('gam:stats').xpath('gam:RunsBattedIn').text,
          :bb => player.xpath('gam:stats').xpath('gam:BatterWalks').text,
          :k => player.xpath('gam:stats').xpath('gam:BatterStrikeouts').text,
          :ip => player.xpath('gam:stats').xpath('gam:InningsPitched').text, 
          :hits_allowed => player.xpath('gam:stats').xpath('gam:HitsAllowed').text,
          :runs_allowed => player.xpath('gam:stats').xpath('gam:RunsAllowed').text,
          :earned_runs => player.xpath('gam:stats').xpath('gam:EarnedRunsAllowed').text,
          :walks_allowed => player.xpath('gam:stats').xpath('gam:PitcherWalks').text,
          :SO => player.xpath('gam:stats').xpath('gam:PitcherStrikeouts').text,
          :hr_allowed => player.xpath('gam:stats').xpath('gam:HomerunsAllowed').text,
        }
  end

  def self.get_boxes(game_id)
      path = "https://api.mysportsfeeds.com/v1.2/pull/mlb/current/game_boxscore.xml?gameid=#{game_id}"
      noko = send_request(path)
      game_hash(noko)

  end

  def self.game_hash(noko)
    game = noko.xpath('gam:gameboxscore')
    away_stats = game.xpath('gam:awayTeam').xpath('gam:awayTeamStats')
    home_stats = game.xpath('gam:homeTeam').xpath('gam:homeTeamStats')
    hash = {
      :away_sts => "",
      :home_sts => ""
    }

    hash[:away_sts] = team_stats(away_stats)
    hash[:home_sts] = team_stats(home_stats)
    
    away = []
    home = []

    game.xpath('gam:inningSummary').xpath('gam:inning').each do |inning|
      away << inning.xpath('gam:awayScore').text
      home << inning.xpath('gam:homeScore').text
    end
    hash[:away_sts][:innings] = away
    hash[:home_sts][:innings] = home

    hash[:away_sts][:name] = game.xpath('gam:game').xpath('gam:awayTeam').xpath('gam:Name').text
    hash[:home_sts][:name] = game.xpath('gam:game').xpath('gam:homeTeam').xpath('gam:Name').text
    
    hash[:away_sts][:final] = game.xpath('gam:inningSummary').xpath('gam:inningTotals').xpath('gam:awayScore').text
    hash[:home_sts][:final] = game.xpath('gam:inningSummary').xpath('gam:inningTotals').xpath('gam:homeScore').text
    hash
  end

  def self.team_stats(nokofile)
    {:innings => [],
    :hits => nokofile.xpath('gam:Hits').text,
    :doubles => nokofile.xpath('gam:SecondBaseHits').text,
    :triples => nokofile.xpath('gam:ThirdBaseHits').text,
    :homers => nokofile.xpath('gam:HomeRuns').text,
    :rbis => nokofile.xpath('gam:RunsBattedIn').text,
    :steals => nokofile.xpath('gam:StolenBases').text,
    :team_avg => nokofile.xpath('gam:BattingAvg').text,
    :team_ops => nokofile.xpath('gam:BatterOnBasePlusSluggingPct').text,
    :pitchks => nokofile.xpath('gam:PitcherStrikeouts').text,
    :teamera => nokofile.xpath('gam:EarnedRunsAllowed').text,
    :teampip => nokofile.xpath('gam:PitchesPerInning').text,
    }
  end

  def self.send_request(path)

    uri = URI(path)


    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_PEER


    req =  Net::HTTP::Get.new(uri)
    req.basic_auth("b99e7738-3a77-40ef-8dca-a7f62d", "Gc2kw3hcRVreqWy")

    res = http.request(req).body
    Nokogiri::XML(res)
    
  end


end