class Baseballcliapiversion::Player
    attr_accessor :name, :at_bats, :hits, :runs, :rbis, :bb, :k, :ip, :hits_allowed, :runs_allowed, :earned_runs, :walk_allowed, :SO, :hr_allowed
    @@all = []

    def self.create_from_hash(player_hash)
        player = Player.new
        player.attrs_from_hash(player_hash)
        player.save
    end

    def attrs_from_hash(player_hash)
        player_hash.each do |k , v|
            send ("#{k}=",v)
        end
    end

    def save
        self.class.all << self
    end

    def self.all
        @@all
    end
end