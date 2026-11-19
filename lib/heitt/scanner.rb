require 'strscan'
require 'set'
require 'json'
require_relative 'analyzer'

module HEITT
  module Scanner

    DATABASE_PATH = File.join(__dir__, 'database.json')
    PROFILES_PATH = File.join(__dir__, 'profiles.json')

    def self.load_database(path = DATABASE_PATH)
      # Symbol keys: the scanner reads entry[:extract_regex], entry[:modes], etc.
      @database ||= JSON.parse(File.read(path), symbolize_names: true).freeze
    end

    def self.load_profiles(path = PROFILES_PATH)
      # Profile names stay strings, fields (:context, :prefixes, ...) become symbols,
      # the same shape the old PROFILES hash had.
      @profiles ||= JSON.parse(File.read(path), symbolize_names: true)
                        .transform_keys(&:to_s).freeze
    end

    def self.scan(input, profiles: load_profiles, min_entropy: 3.5)
      database = load_database
      text = File.exist?(File.expand_path(input)) ? File.read(File.expand_path(input)) : input
      context_scores = HEITT::Analyzer.analyze(text, profiles: profiles)#database: database)
      found = {}
      #seen = {}
     

      database.each do |entry|
        regex = entry[:extract_regex]
        modes = entry[:modes]
        next unless regex && modes && !modes.empty?
        pattern = regex.is_a?(Regexp) ? regex : Regexp.new(regex)
        scanner = StringScanner.new(text)      
        
        while scanner.scan_until(pattern)
          matched = scanner.matched 
          next unless matched.length < 8 || HEITT::Analyzer.high_entropy?(matched, min_entropy)
          offset = scanner.pos - matched.length
          delim_prefix = HEITT::Analyzer.extract_prefix(text, offset)
          candidates = HEITT::Analyzer.score_candidates(modes, delim_prefix, context_scores, profiles: profiles)
          #score = candidates.first[:score]

          found[matched] ||= {hash: matched, candidates: []}
          found[matched][:candidates].concat(candidates)
          end
        end

          found.each_value do |result|
           result[:candidates] = result[:candidates]
            .group_by {|c| c[:name]}
            .map {|name, dupes| dupes.max_by {|c| c[:score]}}
            .sort_by {|c| -c[:score]}

            # Re-assign confidence based on final merged scores
            scores_hash = result[:candidates].map {|c| [c[:name], c[:score]]}.to_h
            prefix_modes = result[:candidates].select {|c| c[:prefix_match]}.map {|c| c[:name]}
            confidences = Analyzer.assign_confidence(scores_hash, prefix_modes)
            result[:candidates] = result[:candidates].map {|c| c.merge(confidence: confidences[c[:name]])}
      end
      found.values
    end
  end
end
