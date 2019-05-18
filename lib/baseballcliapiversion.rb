require "baseballcliapiversion/version"
require "httparty"
require "dotenv/load"

require_relative "baseballcliapiversion/api.rb"
require_relative "baseballcliapiversion/games.rb"
require_relative "baseballcliapiversion/version.rb"
module Baseballcliapiversion
  class Error < StandardError; end
  # Your code goes here...
end
