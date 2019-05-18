class Baseballcliapiversion::Api
    def self.get_games
      d = Date.today.prev_day
      date = d.strftime('%Y%m%d')
      resp = HTTParty.get("https://api.mysportsfeeds.com/v1.2/pull/mlb/current/daily_game_schedule.json?fordate=#{date}", {
          header: {Authorization: Basic {"#{ENV[MySportsFeedCredentials]}"}}
    })
    end
end

Baseballcliapiversion::Api.new.get_games