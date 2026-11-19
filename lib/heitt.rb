require_relative 'heitt/profiles'
require_relative 'heitt/decoder'
require_relative 'heitt/database'
require_relative 'heitt/analyzer'
require_relative 'heitt/scanner'
require_relative 'heitt/grouper'
require_relative 'heitt/formatter'
require_relative 'heitt/version'

module HEITT
  class Identify
    attr_reader :groups

    def initialize(input, database: nil, min_entropy: 3.5, extended: false, show_regex_match: false, verbose: false)
      @extended         = extended
      @show_regex_match = show_regex_match
      @verbose          = verbose

      scan_opts = { min_entropy: min_entropy }
      scan_opts[:database] = database if database
      @groups = Grouper.group(Scanner.scan(input, **scan_opts))
    end

    def tree
      Formatter.tree(@groups, extended: @extended, show_regex_match: @show_regex_match, verbose: @verbose)
    end

    def json
      Formatter.json(@groups, extended: @extended, show_regex_match: @show_regex_match)
    end
  end
end
