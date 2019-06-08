require "baseballcliapiversion/version"
require "nokogiri"
require "dotenv"
require 'net/http'
require 'net/https'
require 'uri'
require 'tty-table'

require_relative "baseballcliapiversion/api"
require_relative "baseballcliapiversion/game"
require_relative "baseballcliapiversion/version"
require_relative "baseballcliapiversion/team"
require_relative "baseballcliapiversion/player"
require_relative "baseballcliapiversion/cli"

module Baseballcliapiversion
  class Error < StandardError; end
  # Your code goes here...
end
