
class Baseballcliapiversion::Team
    attr_accessor :name, :game, :hits, :doubles, :triples, :homers, :rbis, :steals, :team_avg, :team_ops, :pitchks, :teamera, :teampip, :innings, :final, :players
    @@all = []
    
    def self.create_from_hash(hash)
        team = self.new
        team.attrs_from_hash(hash)
        team.save
        team
    end    
    
    def attrs_from_hash(hash)
        hash.each do |k,v|
            send("#{k}=", v)
        end
    end

    def self.create_players
        self.all.each do |team|
            team.players = []
            player_hash = Baseballcliapiversion::Api.get_players(team.game.game_id)
            player_hash[team.name].each do |player|
                play = Baseballcliapiversion::Player.create_from_hash(player)
                play.team = team
                team.players << play
            end
        end
    end

    def final_score
        score = 0
        self.innings.each {|i| score += i.to_i}
        score.to_s
    end

    def save
        self.class.all << self
    end

    def self.all
        @@all
    end


end