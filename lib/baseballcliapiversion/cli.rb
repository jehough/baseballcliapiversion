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
        if (@input.to_i <= Baseballcliapiversion::Game.all.length && @input.to_i > 0)
            game = get_game_info
            create_table(game)
            second_stage(game)
        elsif @input == 'exit'
            @input = 'exit'
        else
            puts "Sorry I didn't understand that, please select a game by number."
            get_user_input
        end
    end

    def get_game_info
        Baseballcliapiversion::Game.find_by_id(@input)
    end
    
    def create_table(game)
        away = game.away_innings_array
        home = game.home_innings_array
        table = TTY::Table.new ['Team', '1', '2', '3', '4', '5', '6', '7', '8', '9', 'Final'], [away, home]
        puts table.render(:unicode)
    end

    def second_stage(game)
        puts "Select a number to see more info or type exit to leave:"
        puts "1. Team stats"
        puts "2. #{game.away_team.name} player stats"
        puts "3. #{game.home_team.name} player stats"
        puts "4. Go back to the list of games"
        @input = gets.chomp
        second_validate(game)
    end

    def second_validate(game)
        if @input == '1'
            team_stats(game)
        elsif @input == '2'
            team = game.away_team
            player_stats(team)
        elsif @input == '3'
            team = game.home_team
            player_stats(team)
        elsif @input == '4'
            list_games
            get_user_input
        else 
            puts "I'm sorry, I didn't get that, please start again"
            list_games
            get_user_input
        end
    end
        
    def team_stats(game)
        away = game.away_team
        home = game.home_team
        table = TTY::Table.new ["Team", "Hits", "Doubles", "Triples", "HRs", "RBIs", "Steals", "AVG", "OPS", "Ks", "ERA", "PPI"],[[away.name, away.hits, away.doubles, away.triples, away.homers, away.rbis, away.steals, away.team_avg, away.team_ops, away.pitchks, away.teamera, away.teampip],[home.name, home.hits, home.doubles, home.triples, home.homers, home.rbis, home.steals, home.team_avg, home.team_ops, home.pitchks, home.teamera, home.teampip]]
        puts table.render(:unicode)
        last_line
    end

    def player_stats(team)
        stats = team.players.collect do |player|
            [player.name,
             player.at_bats,
             player.hits,
             player.runs,
             player.rbis,
             player.bb,
             player.k,
             player.ip,
             player.hits_allowed,
             player.runs_allowed,
             player.SO,
             player.hr_allowed]
            end
        table = TTY::Table.new ["Name", "AB", "Hits", "Runs", "RBIs", "Walks", "Ks", "IP", "Hits Allowed", "Runs Allowed", "Strikeouts", "HR Allowed"],stats
        puts table.render(:unicode)
        last_line
    end

    def last_line
        puts "Press enter to return to games or type exit to leave"
        @input = gets.chomp
    end
end