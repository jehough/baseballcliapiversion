class Baseballcliapiversion::Game
    attr_accessor :game_id, :home_team, :away_team
    @@all
    def initialize (game_id)
        @game_id = game_id
    end

    def self.create_by_array(id_array)
        id_array.each do |game_id|
            game = Game.new(game_id)
            game.save
        end
    end
    
    def self.create_teams
        self.all.each do |game|
            game_id = game.game_id
            hash = Baseballcliapiversion::Api.get_boxes(game_id)
            away = hash[away_sts]
            home = hash[home_sts]
            @away_team = Baseballcliapiversion::Team.create_from_hash(away)
            @home_team = Baseballcliapiversion::Team.create_from_hash(home)
            @away_team.game_id = game
            @home_team.game_id = game
        end
    end
    
    def save
        self.class.all << self
    end
    
    def self.all
        @@all
    end
        
end