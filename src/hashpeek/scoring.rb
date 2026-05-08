require 'strscan'

module HEITT
  #class ContextAnalyzer
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
      

    def classify_hash(modes, delim_prefix, context_scores)
      #possible_matches = []
      #prefix_result = try_prefix_match(modes, delim_prefix)
      #if prefix_result[:matched]
       # return [{name: prefix_result[:matched_mode], confidence: "high", prefix: prefix_result[:prefix]}]
        #confidence: "high"
        #prefix: prefix_result[:prefix], 
      #  }
      #end
      #puts "PREFIX RESULTS: #{prefix_result}"
      #if prefix_result[:matched]
        #boost score as prefix means its really the algorithm
       # return {
        #prefix: prefix_result[:prefix],

        #possible_types: [{
         # name: prefix_result[:matched_mode],
        #}],
        #confidence: "high"
          #mode[:name]],
            #label: result[:label],
           # score: "prefix_matched"
         # }
       #end
        
      #context based scoring
      matches = []
      modes.each do |mode|
        score_data = context_scores[mode[:name]]
        score = score_data ? score_data[:score] : 0

        prefix_result = try_prefix_match(modes, delim_prefix)
        if prefix_result[:matched] && mode[:name] == prefix_result[:matched_mode]
          #boost score as confidence is high if prefix matched
          #puts "MATCHED: #{prefix_result[:matched_mode]}"
          score += 90 #get confidence to high
        end

        if score > 0
          matches << {
            name: mode[:name],
            score: score
          }
        end 
      end
      return [] if matches.empty?

      #calculate confidence
      scores_hash = matches.map {|m| [m[:name], m[:score]]}.to_h 
      scored_results = add_confidence({scores: scores_hash, all_scores: scores_hash.values})

      #convert back to array
      matches.map do |match|
        {
          name: match[:name],
          score: match[:score],
          confidence: scored_results[match[:name]][:confidence]
        }
      end.sort_by {|m| -m[:score]}
    end
        
=begin
        #puts "MODE: #{mode}   |  SCORE DATA: #{score_data}"
        #puts "CONFIDENCE: #{score_data}"
        if score_data
          matches << {
            name: mode[:name],
            score: score_data[:score],
            confidence: score_data[:confidence]
          }
        end
      end
      #puts "AFTER ALL MATCHES: #{matches}"
      if matches.any?
        return{
          prefix: nil,
          possible_types: matches.sort_by {|m| -m[:score]},
          confidence: matches.first[:confidence]
        }
      end
      #puts "MATCHES: #{matches.sort_by {|m| m[:confidence] == "high" ? 0 : (m[:confidence] == "medium" ? 1 : 2)}}"
      #matches.sort_by {|m| m[:confidence] == "high" ? 0 : (m[:confidence] == "medium" ? 1 : 2)}
      #matches


      # Fallback -return all modes with score 0
      {
        prefix: nil,
        possible_types: modes.map {|m| {name: m[:name]}},
        confidence: "low"
      }
=end
    #end


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


    def try_prefix_match(modes, delim_prefix)
      #puts "ALL MODES: #{modes}"
      modes.each do |mode|
       # puts "CURRENT_MODE: #{mode}"
        prefixes = mode[:prefixes] || []
        next if prefixes.empty?
        #return {matched: false} if prefixes.empty?

        delimiters = mode[:delimiters]&.join || '= : '
        text_prefixes = delim_prefix.strip.split(/[#{Regexp.escape(delimiters)}]/)
        raw_prefix = text_prefixes.last&.strip&.downcase
        #puts "DELIMITED PREFIX: #{delim_prefix}"
        #puts "RAW PREFIX: #{raw_prefix}"
        #puts "MATCHED MODE: #{mode[:name]}"
        #puts "TEXT_PREFIXES: #{hash_prefixes}"
        #puts "PREFIXES: #{prefixes}"

        #puts "PREFIX_MAP: #{prefixes.map(&:downcase).include?(raw_prefix)}"

        if prefixes.map(&:downcase).include?(raw_prefix)
          return {
            matched: true,
            prefix: raw_prefix,
            matched_mode: mode[:name]
            #label: mode[:name]
          }
        end
      end

      {matched: false}
    end


    def add_confidence(scoring_result)
      scores = scoring_result[:scores]
      all_scores = scoring_result[:all_scores]

      return {} if scores.empty?

      avg_score = all_scores.sum.to_f / all_scores.size

      scores.transform_values do |score|
      #scores.each do |name, score|
        #if avg_score && avg_score > 0
        deviation = (score - avg_score) / avg_score
        confidence = case deviation
        when 2.0..Float::INFINITY
          "high"
        when 0.5..2.0
          "medium"
        else 
          "low"
        end
        {score: score, confidence: confidence}
      end 
    end

    


    #Methods
    #def initialize(database)
    #def extract_keywords
    #def count_occurences(content_lower)
    #def keyword_counts
    #def all_context_keywords
    #attr_accessor :database, :db_type, :content_lower
    #def initialize(filepath) #type is for extract or identify
    #  @db_type = type
    #  @database = load_database(filepath)
    #end


    #def query(input, extended: false)
    #  if @db_type == :extract
    #    regex_extract(input)
    #  else
    #    find_algorithms(input, extended: extended)
    #  end
    #end

    #private
    #
=begin
    def regex_extract(content)
      found_hashes = []
      content_lower = content.downcase

      #first extract documnt level context
      document_keywords = extract_document_context(content_lower) #Extraction class

      #Prescore algorithms based on document context
      algorithm_scores = score_algorithm_by_context(document_keywords) #Scoring class
      
      @database.each do |entry|
        regex = get_regex(entry)
        modes = get_mode(entry)
        next unless regex && modes #entry_has_extractable_data?(entry)

        pattern = Regexp.new(regex)
        scanner = StringScanner.new(content)
        entry_contexts = entry[:contexts] || []
        #modes = get_modes(entry)

        while scanner.scan_until(pattern)
          #result = extract_hash_with_context(scanner, content, content_lower, modes, entry_contexts)
          matched = scanner.matched
          offset = scanner.pos - matched.length

          #Check entry level context requirement
          #return nil unless entry_context_matches?(entry_contexts, content_lower)

          #Get text before hash on same line (prefix detection)
          before_text = get_line_prefix(content, offset)

          #score and identify the hash based on modes
          classified = classify_hash(modes, before_text, algorithm_scores) #Sorting algorithm

          found_hashes << {
            hash: matched,
            #offset: offset,
            prefix: classified[:prefix],
            possible_types: classified[:possible_types],
            confidence: classified[:confidence]
            #label: classified[:label],
            #score: classified[:score]
          }
         # found_hashes << result if result
        end
      end
      found_hashes.uniq { |h| h[:hash]}
    end
=end



    #def entry_has_extractable_data?(entry)
    #  get_regex(entry) && get_modes(entry)
    #end

    #def extract_hash_with_context(scanner, content, content_lower, modes, entry_contexts)
    #  matched = scanner.matched
    #  offset = scanner.pos - matched.length

      #Check entry level context requirement
      #return nil unless entry_context_matches?(entry_contexts, content_lower)

      #Get text before hash on same line (prefix detection)
      #before_text = get_line_prefix(content, offset)

      #score and identify the hash based on modes
      #classified = classify_hash(modes, before_text, content_lower)

      #{
       # hash: matched,
        #offset: offset,
        #prefix: classified[:prefix],
        #possible_types: classified[:possible_types],
        #confidence: classified[:confidence]
        #label: classified[:label],
        #score: classified[:score]
     # }
    #end

    #def entry_context_matches?(entry_contexts, content_lower)
    #  return true if entry_contexts.empty?
    #  entry_contexts.any? { |c| content_lower.include?(c.downcase)}
    #end



    

    
        #matches = calculate_matching_modes(modes, content_lower)
        #if score > 0 #best_score
          #possible_matches << 
        #  {
         #   prefix: nil,
          #  possible_types: matches,
           # confidence: matches.any? ? "low" : "none"
            #name: mode[:name],
            #score: score
          #}
          #best_score = score
          #best_label = mode[:name]
        #end
     # end

      #{
      #  prefix: nil,
      #  possible_types: possible_matches.sort_by {|m| -m[:score]}.map {|ma| m[:name]},
      #  #label: best_label,
      #  score: possible_matches.any? ? possible_matches.map {|m| m[:score]}.max : 0 #best_score
      #}
    #end

    


    #def calculate_matching_modes(modes, content_lower)
      
    #  matches = []
    #  modes.each do |mode|
    #    mode_contexts = mode[:context] || []
    #    score = mode_contexts.count {|c| content_lower.include?(c.downcase)}
    #    
    #    if score > 0
    #      matches << {
    #        name: mode[:name],
    #        score: score
    #      }
    #    end
    #  end
        #mode_contexts.each do |c|
        #if content_lower.include?(c.downcase)
         # matched << mode[:name]
        #end
      #end
    #  matches.sort_by { |m| -m[:score]} #Highest to lowest
      #mode_contexts.count {|c| content_lower.include?(c.downcase)}
   # end

    


    #def get_regex(entry)
    #  entry[:extract_regex] || entry[:regex] || entry[:pattern] || entry[:regexp]
    #end

    #def get_modes(entry)
      #entry[:modes] || entry[:algorithms] || entry[:hashes] || 
     # entry[:candidates] || entry[:types] || entry[:hashtypes]
    #end

    def load_database(filepath)
      unless File.exist?(filepath)
        puts HEITT.colorize("[ERROR] Database file #{filepath} does not exist", :bold, :red)
        exit(1)
      end

      begin
        file_content = File.read(filepath)
        JSON.parse(file_content, symbolize_names: true)
      rescue JSON::ParserError => e
        puts HEITT.colorize("[ERROR] Invalid JSON in database file: #{e.message}", :bold, :red)
        exit(1)
      end
    end
  end


end
=begin
    def score_algorithm_by_context(keyword_counts)
      scores = {}
      all_scores = []
      return scores if keyword_counts.empty?

      @database.each do |entry|
        entry[:modes].each do |mode|
          mode_contexts = mode[:context] || []
          total_score = mode_contexts.sum {|kw| keyword_counts[kw.downcase] || 0}
          
          if total_score > 0
            scores[mode[:name]] = total_score
            all_scores << total_score
          end
        end
      end
      avg_score = all_scores.sum.to_f / all_scores.size if all_scores.any?
      #scores.each do |name, score|
       # if avg_score && avg_score > 0
        #  deviation = (score-avg_score) / avg_score
         # confidence = case deviation
          #  when 2.0..Float::INFINITY then "high"
          #  when 0.5..2.0 then "medium"
          #  else "low"
          #end
        #else
         # confidence = "low"
       # end
       # scores[name] = {score: score, confidence: confidence}
      #end
      [scores, avg_score]
    end

    def relative_confidence(scores, avg_score)
      scores.each do |name, score|
        if avg_score && avg_score > 0
          deviation = (score-avg_score) / avg_score
          confidence = case deviation
            when 2.0..Float::INFINITY then "high"
            when 0.5..2.0 then "medium"
            else "low"
          end
        else
          confidence = "low"
        end
        scores[name] = {score: score, confidence: confidence}
      end
end
=end

#scorer = HEITT::Scorer.new()
