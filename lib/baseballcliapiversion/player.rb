class Baseballcliapiversion::Player
    attr_accessor :name, 
    def initialize
    end

    def self.create_from_hash(player_hash)
        player = Player.new
        player.attrs_from_hash(player_hash)
    end

    def attrs_from_hash(player_hash)
        player_hash.each do |k , v|
            send ("#{k}=",v)
        end
    end

end