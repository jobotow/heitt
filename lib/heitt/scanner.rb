require 'strscan'
require 'set'
require_relative 'analyzer'
require_relative 'database'
require_relative 'profiles'

module HEITT
  module Scanner

    def self.scan(input, database: HEITT::DATABASE, profiles: HEITT::PROFILES, min_entropy: 3.5)
      text = File.exist?(File.expand_path(input)) ? File.read(File.expand_path(input)) : input
      context_scores = HEITT::Analyzer.analyze(text, profiles: profiles)#database: database)
      found = {}
      #seen = {}
     

      database.each do |entry|
        regex = get_regex(entry)
        modes = get_modes(entry)
        next unless regex && modes && !modes.empty?
        pattern = regex.is_a?(Regexp) ? regex : Regexp.new(regex)
        scanner = StringScanner.new(text)      
        
        while scanner.scan_until(pattern)
          matched = scanner.matched 
          next unless matched.length < 8 || HEITT::Analyzer.high_entropy?(matched, min_entropy)
          offset = scanner.pos - matched.length
          HEITT::Logger.debug("Extracting prefix..")
          delim_prefix = HEITT::Analyzer.extract_prefix(text, offset)
          HEITT::Logger.debug("Extracted prefix: #{delim_prefix.length <= 1 ? "NULL" : delim_prefix}")

          candidates = HEITT::Analyzer.score_candidates(modes, delim_prefix, context_scores)
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
            confidences = Analyzer.assign_confidence(scores_hash)
            result[:candidates] = result[:candidates].map {|c| c.merge(confidence: confidences[c[:name]])}
      end
      found.values
    end

    private
    
    def self.get_regex(entry)
      entry[:extract_regex] || entry[:regex] || entry[:pattern] || entry[:regexp]
    end

    def self.get_modes(entry)
      entry[:modes] || entry[:algorithms] || entry[:hashes] || 
      entry[:candidates] || entry[:types] || entry[:hashtypes]
    end
  end
end