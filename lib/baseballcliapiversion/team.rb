
class Baseballcliapiversion::Team
    attr_accessor :name, :game_id, :hits, :doubles, :triples, :homers, :rbis, :steals, :team_avg, :team_ops, :pitchks, :teamera, :teampip, :innings
    
    def self.create_from_hash(hash)
        team = self.new
        team.attrs_from_hash(hash)
    end    
    
    def attrs_from_hash(hash)
        hash.each do |k,v|
            send ("#{k}=", v)
        end
    end
end