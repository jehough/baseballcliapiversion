class Baseballcliapiversion::Game
    attr_accessor :game_id, :home_team, :away_team, :name
    @@all = []
    def initialize (game_id)
        @game_id = game_id
    end

    def self.create_by_array(id_array)
        id_array.each do |game_id|
            game = self.new(game_id)
            game.save
        end
    end
    
    def self.create_teams
        self.all.each do |game|
            game_id = game.game_id
            hash = Baseballcliapiversion::Api.get_boxes(game_id)
            game.build_teams(hash)
        end
    end
    
    def build_teams(hash)
        away = hash[:away_sts]
        home = hash[:home_sts]
        self.away_team = Baseballcliapiversion::Team.create_from_hash(away)
        self.home_team = Baseballcliapiversion::Team.create_from_hash(home)
        self.away_team.game = self
        self.home_team.game = self
        self.name = "#{@away_team.name} vs #{@home_team.name}"
    end


    def self.find_by_id(input)
        index = input.to_i - 1
        self.all[index]
    end

    def save
        self.class.all << self
    end
    
    def self.all
        @@all
    end
    

end