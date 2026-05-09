require 'strscan'

module HEITT
  
  class HashDatabase
    attr_accessor :database, :db_type
    def initialize(filepath, type=:identify) #type is for extract or identify
      @db_type = type
      #@database = HEITT::Database.load(database, custom_database)#load_database(filepath)
    end


    def query(input, extended: false)
      if @db_type == :extract
        regex_extract(input)
      #else
       # find_algorithms(input, extended: extended)
      end
    end

    private
    #def find_algorithms(hash, extended: false)
     # matched = []
     # @database.each do |entry|
     #   regex = get_regex(entry)
     #   modes = get_modes(entry)
     #   next unless regex #skip metadata entries
     #   next unless modes
     #   pattern = Regexp.new(regex)
     #   if hash =~ pattern
     #     matched.concat(modes.select {|algo| extended || !algo[:extended]}.map { |algo| HashAlgo.new(algo)})
     #   end
     # end
     # matched.any? ? [matched, true] : [[], false]
    #end


    def regex_extract(content, context_window: 50)
      found_hashes = []
      content_lower = content.downcase

      #first extract documnt level context
      document_keywords = extract_document_context(content_lower)

      #Prescore algorithms based on document context
      algorithm_scores = score_algorithm_by_context(document_keywords)
      
      @database.each do |entry|
        next unless entry_has_extractable_data?(entry)

        pattern = Regexp.new(get_regex(entry))
        scanner = StringScanner.new(content)
        entry_contexts = entry[:contexts] || []
        modes = get_modes(entry)

        while scanner.scan_until(pattern)
          #result = extract_hash_with_context(scanner, content, content_lower, modes, entry_contexts)
          matched = scanner.matched
          offset = scanner.pos - matched.length

          #Check entry level context requirement
          #return nil unless entry_context_matches?(entry_contexts, content_lower)

          #Get text before hash on same line (prefix detection)
          before_text = get_line_prefix(content, offset)

          #score and identify the hash based on modes
          classified = classify_hash(modes, before_text, algorithm_scores)

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



    def entry_has_extractable_data?(entry)
      get_regex(entry) && get_modes(entry)
    end

    def extract_hash_with_context(scanner, content, content_lower, modes, entry_contexts)
      matched = scanner.matched
      offset = scanner.pos - matched.length

      #Check entry level context requirement
      return nil unless entry_context_matches?(entry_contexts, content_lower)

      #Get text before hash on same line (prefix detection)
      before_text = get_line_prefix(content, offset)

      #score and identify the hash based on modes
      classified = classify_hash(modes, before_text, content_lower)

      {
        hash: matched,
        offset: offset,
        prefix: classified[:prefix],
        possible_types: classified[:possible_types],
        confidence: classified[:confidence]
        #label: classified[:label],
        #score: classified[:score]
      }
    end

    def entry_context_matches?(entry_contexts, content_lower)
      return true if entry_contexts.empty?
      entry_contexts.any? { |c| content_lower.include?(c.downcase)}
    end

    def collect_all_context_keywords
      @database.flat_map do |entry|
        entry[:modes].flat_map {|mode| mode[:context] || []}
      end.uniq.map(&:downcase)
    end

    def extract_document_context(content_lower)
      keywords = collect_all_context_keywords
      counts = {}
      keywords.each do |kw|
        count = content_lower.scan(/\b#{Regexp.escape(kw)}\b/).size
        counts[kw] = count if count > 0
      #keywords.select { |kw| content_lower.include?(kw)}
      end
      counts
    end

    def score_algorithm_by_context(keyword_counts)
      scores = {}
      all_scores = []
      return scores if keyword_counts.empty?

      @database.each do |entry|
        entry[:modes].each do |mode|
          mode_contexts = mode[:context] || []
          total_score = mode_contexts.sum {|kw| keyword_counts[kw.downcase] || 0}
          
          if total_score > 0
           # confidence_percent = (total_score.to_f / max_possible) * 100
            scores[mode[:name]] = total_score
            all_scores << total_score
          end
        end
      end
      avg_score = all_scores.sum.to_f / all_scores.size if all_scores.any?
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
      scores
        #scores 
    end

    def get_line_prefix(content, offset)
      line_start = content.rindex(/[\n ]/, offset) || 0
      content[line_start...offset]
    end
      

    def classify_hash(modes, before_text, algorithm_scores)
      possible_matches = []
      #best_score = 0
      #best_label = nil 
      #found_prefix = nil 

      #modes.each do |mode|
        #Check prefix match first 
      prefix_result = try_prefix_match(modes, before_text)
      if prefix_result[:matched]
        return {
        prefix: prefix_result[:prefix],
        possible_types: [{
          name: prefix_result[:matched_mode],
        }],
        confidence: "high"
          #mode[:name]],
            #label: result[:label],
           # score: "prefix_matched"
          }
       end
        
       #Document context scoring
        matches = []
        modes.each do |mode|
          score_data = algorithm_scores[mode[:name]]
          if score_data
            matches << {
                name: mode[:name],
                score: score_data[:score],
                confidence: score_data[:confidence]
            }
          end
        end
        if matches.any?
            return{
                prefix: nil,
                possible_types: matches.sort_by {|m| -m[:score]},
                confidence: matches.first[:confidence]
            }
        end

        # Fallback -return all modes with score 0
        {
            prefix: nil,
            possible_types: modes.map {|m| {
                name: m[:name]
            }},
            confidence: "low"
        }
      end

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

    def try_prefix_match(modes, before_text)
      modes.each do |mode|
        prefixes = mode[:prefixes] || []
        next if prefixes.empty?
        #return {matched: false} if prefixes.empty?

        delimiters = mode[:delimiters]&.join || '= : '
        before_words = before_text.strip.split(/[#{Regexp.escape(delimiters)}]/)
        last_word = before_words.last&.strip&.downcase

        if prefixes.map(&:downcase).include?(last_word)
          return {
            matched: true,
            prefix: last_word,
            matched_mode: mode[:name]
            #label: mode[:name]
          }
        end
      end

      {matched: false}
    end


    def calculate_matching_modes(modes, content_lower)
      
      matches = []
      modes.each do |mode|
        mode_contexts = mode[:context] || []
        score = mode_contexts.count {|c| content_lower.include?(c.downcase)}
        
        if score > 0
          matches << {
            name: mode[:name],
            score: score
          }
        end
      end
        #mode_contexts.each do |c|
        #if content_lower.include?(c.downcase)
         # matched << mode[:name]
        #end
      #end
      matches.sort_by { |m| -m[:score]} #Highest to lowest
      #mode_contexts.count {|c| content_lower.include?(c.downcase)}
    end

    


    def get_regex(entry)
      entry[:extract_regex] || entry[:regex] || entry[:pattern] || entry[:regexp]
    end

    def get_modes(entry)
      entry[:modes] || entry[:algorithms] || entry[:hashes] || 
      entry[:candidates] || entry[:types] || entry[:hashtypes]
    end

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
