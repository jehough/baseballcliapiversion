class Baseballcliapiversion::Cli
    attr_accessor :input
    def call
        make_games
        make_teams
        make_players
        while input != 'exit'
            list_games
            get_user_input
        end
    end

    def make_games
        games_array = Baseballcliapiversion::Api.game_ids
        Baseballcliapiversion::Game.create_by_array(games_array)
    end

    def make_teams
        Baseballcliapiversion::Game.create_teams
    end

    def make_players
        Baseballcliapiversion::Team.create_players
    end

    def list_games
        Baseballcliapiversion::Game.all.each_with_index do |game, i|
            puts (i + 1).to_s + ". #{game.name}"
        end
    end

    
end