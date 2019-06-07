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
    
    def save
        self.class.all << self
    end
    
    def self.all
        @@all
    end
        
end