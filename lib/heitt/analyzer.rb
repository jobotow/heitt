require_relative 'utils'
require_relative 'profiles'

module HEITT
  module Analyzer
    def self.analyze(text, profiles: HEITT::PROFILES)#database: HEITT::DATABASE)
      HEITT::Logger.debug("Counting keywords...")
      keyword_counts = keyword_counts(text.downcase, profiles: profiles)
      HEITT::Logger.debug("Counted keywords: #{keyword_counts}")
      algorithm_scores(keyword_counts, profiles: profiles)
    end

    def self.extract_prefix(text, offset)
      line_start = text.rindex("\n", offset) || 0
      text[line_start...offset]
    end

    def self.high_entropy?(text, min_ent)
      entropy(text) >= min_ent
    end
      

    def self.score_candidates(modes, delim_prefix, context_scores, profiles: HEITT::PROFILES)
      prefix_matched_mode = nil
      #context based scoring
      matches = modes.map do |mode|
        profile = profiles[mode[:name]] || {}
        score = context_scores[mode[:name]] || 0
        #score = score_data || 0

        if prefix_match?(profile, delim_prefix)
          #boost score as confidence is high if prefix matched
          prefix_matched_mode = mode[:name]
          score += 20
        end
        {
          name: mode[:name],
          hashcat: mode[:hashcat],
          john: mode[:john],
          extended: mode[:extended],
          description: profile[:description],
          score: score
        }
      end 
      return [] if matches.empty?

      #calculate confidence
      scores_hash = matches.map {|m| [m[:name], m[:score]]}.to_h 
      
      confidences = assign_confidence(scores_hash, prefix_matched_mode)
      scored_candidates = matches.map{|m| m.merge(confidence: confidences[m[:name]])}.sort_by {|m| -m[:score]}
      HEITT::Logger.debug("Scored Algorithm: #{scored_candidates.map{|s| s[:name] }}  =>   Calculated Confidence: #{scored_candidates.map{|s| s[:confidence] }}")
      scored_candidates
    end


    private
    #def self.get_modes(entry)
    #  entry[:modes] || entry[:algorithms] || entry[:hashes] || 
    #  entry[:candidates] || entry[:types] || entry[:hashtypes]
    #end

    #this  code is an inspiration of "https://github.com/chrisjchandler/entropy/blob/main/entropy.go"
    def self.entropy(text)
      frequency = Hash.new(0)
      text.each_char { |ch| frequency[ch] += 1 }

      #calculate the total number of characters
      total = text.length.to_f
      #caluclate entropy
      entropy = 0.0
      frequency.each_value do |count|
        probability = count.to_f / total
        entropy += probability * Math.log2(probability)
      end
      #negate the sum as entropy is positive
      -entropy
    end
    
    def self.keyword_counts(content_lower, profiles: HEITT::PROFILES) #HEITT::DATABASE)
      keywords = profiles.values.flat_map { |p| p[:context] || [] }.uniq.map(&:downcase)
      #database.flat_map do |entry|
        #modes = get_modes(entry)
        #next [] unless modes
        #modes.flat_map {|mode| HEITT::PROFILES[mode[:name]][:context] || []}
      #end#.uniq.map(&:downcase)

      counts = {}
      keywords.each do |kw|
        count = content_lower.scan(/\b#{Regexp.escape(kw)}\b/).size
        counts[kw] = count if count > 0
      end
      counts
    end


    def self.algorithm_scores(keyword_counts, profiles: HEITT::PROFILES)#database: HEITT::DATABASE)
      scores = {}
      return scores if keyword_counts.nil?

      profiles.each do |name, profile| #database.each do |entry|
        context = profile[:context] || []
        next if context.empty?
        #modes = get_modes(entry)
        #next unless modes
        #modes.each do |mode|
        #  contexts = mode[:context] || []
        #  next if contexts.empty?
        total = context.sum {|kw| keyword_counts[kw.downcase] || 0}
        scores[name] = total if total > 0
      #  end
      end
      scores
    end


    def self.prefix_match?(profile, delim_prefix)
      #prefixes = mode[:prefixes] || []
      prefixes = profile[:prefixes] || []
      return false if prefixes.empty?

      delimiters =  "= : "
      raw_prefix = delim_prefix.strip.split(/[#{Regexp.escape(delimiters)}]/).last&.strip&.downcase
      prefixes.map(&:downcase).include?(raw_prefix)
    end


    def self.assign_confidence(scores_hash,  prefix_matched_mode=nil)
      all_scores = scores_hash.values

      return {} if all_scores.empty?

      avg_score = all_scores.sum.to_f / all_scores.size
     
      scores_hash.transform_values do |score|
        if score == 0
          "regex-match"
        else
          mode_name = scores_hash.key(score)
          is_prefix_mode = (prefix_matched_mode == mode_name)
          deviation = (score - avg_score) / avg_score

          case deviation
          when 2.0..Float::INFINITY
            "high"
          when 0.5..2.0
            is_prefix_mode ? "high" : "medium-high"
          else
            is_prefix_mode ? "medium-high" : "medium-low"
          end
        end 
      end
    end
  end
  #private_constant :Analyzer
end