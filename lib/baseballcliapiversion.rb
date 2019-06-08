require "baseballcliapiversion/version"
require "nokogiri"
require "dotenv/load"
require 'net/http'
require 'net/https'
require 'uri'
require 'tty-table'

require_relative "baseballcliapiversion/api"
require_relative "baseballcliapiversion/games"
require_relative "baseballcliapiversion/version"
module Baseballcliapiversion
  class Error < StandardError; end
  # Your code goes here...
end
