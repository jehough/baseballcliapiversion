class Baseballcliapiversion::Game
    attr_accessor :game_id, :home_team, :away_team
    def initialize (game_id)
        @game_id = game_id
    end

end