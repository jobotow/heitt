require 'strscan'

module HEITT
  class Scorer
    attr_accessor :database

    def initialize(database)
      @database = database
    end

    def analyze(content_lower)
      keyword_counts = extract_keywords(content_lower)
      scores = score_algorithms(keyword_counts)
      add_confidence(scores)
    end

    def get_prefix(content, offset)
      line_start = content.rindex("\n", offset) || 0
      content[line_start...offset]
    end
      

    def collect_scored_matches(modes, delim_prefix, context_scores)
        
      prefix_matched_mode = {}
      #context based scoring
      matches = []
      modes.each do |mode|
        score_data = context_scores[mode[:name]]
        score = score_data ? score_data[:score] : 0

        prefix_result = try_prefix_match(mode, delim_prefix)

        if prefix_result[:matched] && mode[:name] == prefix_result[:matched_mode]
          #boost score as confidence is high if prefix matched
          prefix_matched_mode = prefix_result[:matched_mode]
          score += 20
        end

        #if score > 0
          matches << {name: mode[:name], score: score}
        #else
         # puts "NAME: #{mode[:name]}   |  SCORE: #{score}"
          #matches << {name: mode[:name], score: score, confidence: "format_match"}
       # end 
      end
      return [] if matches.empty?

      #calculate confidence
      scores_hash = matches.map {|m| [m[:name], m[:score]]}.to_h 
      scored_results = add_confidence({scores: scores_hash, all_scores: scores_hash.values}, prefix_matched_mode)

      #convert back to array
      matches.map do |match|
        #puts "MATCHES MAP ||  NAME: #{match[:name]}  || SCORE: #{match[:score]}  || CONFIDENCE: #{scored_results[match[:name]][:confidence]}"
        {
          name: match[:name],
          score: match[:score],
          confidence: scored_results[match[:name]][:confidence]
        }
      end.sort_by {|m| -m[:score]}
    end


    private
    def extract_keywords(content_lower)
      all_keywords = collect_all_keywords
      count_occurences(content_lower, all_keywords)
    end

    def collect_all_keywords
      @database.flat_map do |entry|
        entry[:modes].flat_map {|mode| mode[:context] || []}
      end.uniq.map(&:downcase)
    end


    def count_occurences(content_lower, keywords)
      counts = {}
      keywords.each do |kw|
        count = content_lower.scan(/\b#{Regexp.escape(kw)}\b/).size
        counts[kw] = count if count > 0
      end
      counts
    end


    def score_algorithms(keyword_counts)
      scores = {}
      all_scores = []
      return scores if keyword_counts.empty?

      @database.each do |entry|
        entry[:modes].each do |mode|
          mode_contexts = mode[:context] || []
          next if mode_contexts.empty?
          total_score = mode_contexts.sum {|kw| keyword_counts[kw.downcase] || 0}
          
          if total_score > 0
            scores[mode[:name]] = total_score
            all_scores << total_score
          end
        end
      end
      {scores: scores, all_scores: all_scores}
    end


    def try_prefix_match(mode, delim_prefix)
        prefixes = mode[:prefixes] || []
        return {matched: false} if prefixes.empty?

        delimiters = mode[:delimiters]&.join || '= : '
        text_prefixes = delim_prefix.strip.split(/[#{Regexp.escape(delimiters)}]/)
        raw_prefix = text_prefixes.last&.strip&.downcase

        if prefixes.map(&:downcase).include?(raw_prefix)
          return {matched: true, prefix: raw_prefix, matched_mode: mode[:name]}
        end

      {matched: false}
    end


    def add_confidence(scoring_result,  prefix_matched_mode=nil)
      scores = scoring_result[:scores]
      all_scores = scoring_result[:all_scores]

      return {} if scores.empty?

      #if all_scores.all? {|s| s == 0}
       # return scores.transform_values do |score|
        #  {score: score, confidence: "format-match"}
       # end
      #end

      

      avg_score = all_scores.sum.to_f / all_scores.size
     
      scores.transform_values do |score|
        if score == 0
          {score: score, confidence: "regex-match"}
        else
          mode_name = scores.key(score)
          is_prefix_mode = (prefix_matched_mode == mode_name)
          deviation = (score - avg_score) / avg_score

          confidence = case deviation
          when 2.0..Float::INFINITY
            "high"
          when 0.5..2.0
            is_prefix_mode ? "high" : "medium-high"
          else
            is_prefix_mode ? "medium-high" : "medium-low"
          end
          {score: score, confidence: confidence}
        end 
      end
    end
  end
end