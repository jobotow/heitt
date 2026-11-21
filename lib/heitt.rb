require_relative 'heitt/analyzer'
require_relative 'heitt/scanner'
require_relative 'heitt/grouper'
require_relative 'heitt/formatter'
require_relative 'heitt/version'

module HEITT
  class Identify
    attr_reader :groups

    def initialize(input, min_entropy: 3.5)
      scan_opts = { min_entropy: min_entropy }
      @groups = Grouper.group(Scanner.scan(input, **scan_opts))
    end

    # Options given here override the ones passed to new, so both
    # Identify.new(f, detailed: true).tree and Identify.new(f).tree(detailed: true) work.
    def tree(detailed: false, show_unscored: false)
      Formatter.tree(@groups, detailed: detailed, show_unscored: show_unscored)
    end

    def json(detailed: false, show_unscored: false)
      Formatter.json(@groups, detailed: detailed, show_unscored: show_unscored)
    end
  end
end
