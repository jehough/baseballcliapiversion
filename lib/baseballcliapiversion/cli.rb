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

    def get_user_input
        puts "Select a game to see more information"
        @input = gets.chomp
        validate_input
    end

    def validate_input
        if (@input.to_i <= Baseballcliapiversion.Game.all.length && @input.to_i > 0)
            game = get_game_info
            create_table(game)
        else
            puts "Sorry I didn't understand that, please select a game by number."
            get_user_input
        end
    end

    def get_game_info
        Baseballcliapiversion::Game.find_by_id(@input)
    end
    
    def create_table(game)
    end
    
end