require 'json'
require 'set'
#require_relative '../cli_flag'
require_relative 'colors'
require_relative 'outfmt'
#require_relative 'dbase'
require_relative 'setup'

module HEITT

  class StreamGroupResults
    attr_accessor :groups, :total_hashes
  
    def initialize(groups, total_hashes)
      @groups = groups
      @total_hashes = total_hashes
    end

    def tree_format(verbose: false)
      HEITT.tree_group_format(self, verbose: verbose)
    end

    def json_format
      HEITT.json_group_format(self)
    end
  end
  #private_constant :StreamGroupResults

  class AnalysisResult
    attr_accessor :hash, :algorithms, :found
    def initialize(hash, algorithms, found)
      @hash = hash
      @algorithms = algorithms || []
      @found = found
    end
  end
  private_constant :AnalysisResult

 
  class HashAlgo
    attr_accessor :name, :description, :hashcat, :john, :characteristics, :notes, :extended, :score, :confidence, :matched

    def initialize(attributes = {})
      @name = attributes[:name]
      @description = attributes[:description] || ""
      @hashcat = attributes[:hashcat] || "--"
      @john = attributes[:john] || "--"
      #release only when verbose mode
      @characteristics = attributes[:characteristics] || ""
      @notes = attributes[:notes] || []
      @extended = attributes[:extended] || false
      @score = attributes[:score] || 0
      @confidence = attributes[:confidence] #|| "low",
      @matched= attributes[:matched]
    end

  end
  private_constant :HashAlgo

    
  class Identifier
    attr_accessor :database, :hash_counts, :ident_results, :hash_lists, :total_hashes

    def initialize(custom_database=nil)
      @database = HEITT::Database.new.load("hash_database", custom_database)
      @hash_counts = {}
      @ident_results = {}
      @hash_lists = {}
      @total_hashes = 0
    end


    def <<(input)
      stream_identify(input)
      self
    end

    def finalize(extended: false)
      get_stream_results(extended: extended)
    end

    def batch_identify(hashes, extended: false)
      hashes.each do |hash|
        stream_identify(hash)
      end
      finalize(extended: extended)
    end


    



    

    
    private 
    #made flexible for custom databases
    def get_regex(entry)
      entry[:regex] || entry[:pattern] || entry[:regexp]
    end

    def get_modes(entry)
      entry[:modes] || entry[:algorithms] || entry[:hashes] || 
      entry[:candidates] || entry[:types] || entry[:hashtypes]
    end

    def find_algorithms(input, extended: false)
      matched = []
      @database.each do |entry|
        regex = get_regex(entry)
        modes = get_modes(entry)
        
        next unless regex and modes #skip metadata entries
        pattern = Regexp.new(regex)
        if input =~ pattern
          matched.concat(modes.select {|algo| extended || !algo[:extended]}.map { |algo| HashAlgo.new(algo)})
        end
      end
      matched.any? ? [matched, true] : [[], false]
    end


    def find_algorithms_with_scores(input, possible_types, extended: false)
      #return [] unless hash_matches_format?(input)
      #puts "HASH MATCHES FORMAT: #{hash_matches_format?(input)}"
      #matched = []
      possible_types.map do |pt|

      #filtered_types.each do |pt|
       # puts "PT_NAME: #{pt[:name]}"
        db_mode = find_mode_in_database(pt[:name], extended: extended)
        #puts  "BOOLEAN: #{db_mode[:extended]}"

        #next if db_mode&.[]("extended") && !extended
        #puts "DB_MODE: #{db_mode.inspect}"
        next if db_mode.nil?

        HashAlgo.new({
            name: pt[:name],
            description: db_mode[:description] || "",
            hashcat: db_mode[:hashcat] || "--", 
            john: db_mode[:john] || "--", 
            characteristics: db_mode[:characteristics] || "",
            notes: db_mode[:notes] || [],
            extended: db_mode[:extended] || false,
            score: pt[:score],
            confidence: pt[:confidence]
        })
      end.compact
      #matched
    end

    def hash_matches_format?(hash_string)
      @database.each do |entry|
        regex = get_regex(entry)
        next unless regex
        return true if Regexp.new(regex).match?(hash_string)
      end
      false
    end

    def find_mode_in_database(mode_name, extended: false)
      @database.each do |entry|
        modes = get_modes(entry)
        next unless modes
        modes.each do |mode|
          next if mode[:extended] && !extended

          #db_name = mode["name"] || mode[:name]
          #puts "CHOSEN MODE: #{mode}"
          #puts "RETURNING MODE: #{mode if db_name.to_s.casecmp(mode_name.to_s).zero?}"
          return mode if mode[:name].to_s.casecmp(mode_name.to_s).zero?
        end
      end
      nil
    end

      #matched = []
      #@database.each do |entry|
       # regex = get_regex(entry)
      #  modes = get_modes(entry)
        
        #next unless regex and modes #skip metadata entries
        #pattern = Regexp.new(regex)
        #if input =~ pattern
         # puts "MODES: #{modes}"
         # matched_modes = merge_scores_with_modes(modes, possible_types, extended)
          #puts "MATCHED_MODES: #{matched_modes}"
          #matched.concat(matched_modes)
          #matched.concat(modes.select {|algo| extended || !algo[:extended]}.map { |algo| HashAlgo.new(algo)})
        #end
      #end
     # matched.any? ? [matched, true] : [[], false]
    #end

    def get_mode_name(db_mode)
      name = db_mode["name"] #|| db_mode[:name]
      puts "NAME: #{name}"
      return nil if name.nil?
      name
    end

=begin

    def merge_scores_with_modes(modes, possible_types, extended)
      matched = []
      modes.map do |db_mode|
        #puts "DB_MODE: #{db_mode}"
        next if db_mode["extended"] && !extended

        #Find matching score
        puts "POSSIBLE_TYPES CLASS: #{possible_types.class}" 
        puts "POSSIBLE_TYPES: #{possible_types}" 
        mode_name = db_mode[:name]
        puts "MODE NAME: #{db_mode[:name]}"
        next unless mode_name
        match = possible_types.find do |pt| 
          #mode_name = db_mode["name"] || db_mode[:name]
          #next false if mode_name.nil?
          pt_name = pt[:name].to_s
          db_name = db_mode[:name].to_s
          "PT_NAME: #{pt_name}"
          puts "Comparing '#{pt_name}' vs '#{db_name}'"
          puts "casecmp result: #{pt_name.casecmp(db_name)}"
          puts "zero? result: #{pt_name.casecmp(db_name).zero?}"
          puts "FINDING........................\n"
          result = (pt[:name]||pt["name"]).to_s.casecmp(mode_name).zero?
          #puts "PT_NAME: #{pt_name.inspect}"
          #puts "PT_CLASS: #{pt_name.class}"
          #db_name = db_mode["name"] #|| #db_mode[:name]
          #next false unless pt_name && db_name
          #pt_name.casecmp(db_name).zero?
        end
        #end
        #db_mode.each do |single_mode|
        #  match = possible_types.find {|pt| pt[:name].casecmp(single_mode["name"]).zero?}
        #end
        puts "MATCHED: #{match}"
        #puts "SCORE: #{match[:score]}"
        puts "DB_MODE: #{db_mode}"
        if match && match[:score]
          matched << HashAlgo.new({
            name: db_mode["name"],
            description: db_mode["description"] || "",
            hashcat: db_mode["hashcat"] || "--",
            john: db_mode["john"] || "--",
            characteristics: db_mode["characteristics"] || "",
            notes: db_mode["notes"] || [],
            extended: db_mode["extended"] || false,
            score: match[:score],
            confidence: match[:confidence]
          })
        #end
        #else
        #HashAlgo.new({
        #    name: db_mode["name"],
        #    description: db_mode["description"] || "",
        #    hashcat: db_mode["hashcat"] || "--",
        #    john: db_mode["john"] || "--",
        #    characteristics: db_mode["characteristics"] || "",
        #    notes: db_mode["notes"] || [],
        #    extended: db_mode["extended"] || false,
        #    score: nil,
         #   confidence: nil,
         #   matched: false,
         # })
        end
      end
      matched
      #end.compact
    end
=end


    def identify(input, extended: false)
      if input.is_a?(Hash) && input[:hash] && input[:possible_types]
        hash_string = input[:hash]
        possible_types = input[:possible_types]
        algorithms = find_algorithms_with_scores(hash_string, possible_types, extended: extended)
        AnalysisResult.new(hash_string, algorithms, !algorithms.nil?)
      #else
       # hash_string = input.to_s.strip
       # algorithms, found = find_algorithms(hash_string, extended: extended)
       # AnalysisResult.new(hash_string, algorithms, found)
      end
    end


    def stream_identify(input)
      #puts "INPUT TYPE: #{input.class}"
      if input.is_a?(Hash) && input[:hash]
        #puts "GIVEN HASH: #{input[:hash]}"
        ident_result = identify(input)
        #identify returns nil for md5 and above hashes
        #puts "IDENT RESULT #{ ident_result.inspect}"
        hash_string = input[:hash]

        #Get top algorithms from possible_types
        top_algo = input[:possible_types]&.first
        #puts "TOP ALGO: #{top_algo ? top_algo[:name] : ident_result.algorithms.first[:name]}"
        #puts  "CLADSSY: #{ident_result.algorithms.first[:name]}"
        algorithm_name = if top_algo 
         # puts "YES: top_algo: #{top_algo}"
          top_algo[:name] || top_algo["name"]
        elsif  ident_result.algorithms && ident_result.algorithms.any?
          #puts "ANY IS AVAILABLE"
          #puts "FIRST NAME: #{ident_result.algorithms}"
          ident_result.algorithms.first[:name]
        end
        #puts "ALGO_NAME: #{algorithm_name}"
      else
        ident_result = identify(input)
        hash_string = input
        algorithm_name = ident_result.algorithms.first&.name
      end

      return if hash_string.empty? || algorithm_name.nil?
      @total_hashes += 1
      if @hash_counts.key?(algorithm_name)
        @hash_counts[algorithm_name] += 1
        @hash_lists[algorithm_name] << hash_string
      else
        @hash_counts[algorithm_name] = 1
        @ident_results[algorithm_name] = ident_result
        @hash_lists[algorithm_name] = [hash_string]
      end
    end

    def get_stream_results(extended: false)
      groups = []
      
      if @total_hashes > 0 
        @hash_counts.each_with_index do |(algorithm_name, count), index|
          mode = find_mode_in_database(algorithm_name)
          next if mode.nil?
          
          percent = ((count.to_f / @total_hashes.to_f) * 100).round(2)
          ident_result = @ident_results[algorithm_name]

          groups << {
            identified_result: ident_result, 
            cluster_id: groups.size + 1,
            count: count, 
            percent: percent, 
            hashes: @hash_lists[algorithm_name]
          }
        end
      end
      #groups
      result = StreamGroupResults.new(groups, @total_hashes)
      reset
      result
    end

    def reset
      @hash_counts.clear
      @total_hashes = 0
      @ident_results.clear
      @hash_lists.clear
    end

    def file_count_line(filename)
      line_count = 0
      unless File.exist?(filename)
        puts HEITT.colorize("[ERROR] #{filename} does not exist", :bold, :red)
        exit(0)
      end

      begin
        File.foreach(filename) do |line|
          clean_line = line.strip
          line_count += 1 unless clean_line.empty?
        end
      rescue IOError => e
        puts HEITT.colorize("[ERROR] Cannot open or read #{filename}: #{e.message}", :bold, :red)
      end
      line_count
    end
  end
end

#Usage

#hash = "aabb"
#hash = "b1946ac92492d2347c6235b4d2611184"
#analyzer = HEITT::HashAnalyzer.new
#puts "RESULTS: #{analyzer.identify(hash)}"
#single hash analysis
#analyzer = HEITT::HashAnalyzer.new
#result = analyzer.identify("b1946ac92492d2347c6235b4d2611184")

#Stream processing
ident = HEITT::Identifier.new
#ident.stream_identify("abcd")
#ident.stream_identify("cdef")

#ident << "abcd" << "cdef"
#result = ident.finalize
#result = ident.identify("abdd")
#puts "RESULTS: #{result.json_format}"

#ident.batch_identify(["abcd", "bcde", "aabb"]) do |single|
 #  puts "FOund: #{single.json_format}"
#end

#analyze = HEITT::Identifier.new()
#hashes = ["a95c9b6ab0e338f225f5f7595c7674b7","b1946ac92492d2347c6235b4d2611184", "5891b5b522d5df086d0ff0b110fbd9d21bb4fc7163af34d08286a2e846f6be03", "e73b7fc75f15461894e98ce26c773e9e"]
#puts analyze.batch_identify(hashes).tree_format
#puts analyze.identify("b1946ac92492d2347c6235b4d2611184").json_format

#puts "STREAM: #{ident.get_stream_results}"
#analyzer.stream_identify("hash1")
#analyzer.stream_identify("hash2")
#result = analyze.get_stream_results

#Custom database
#custom_db = HEITT::HashDatabase.new("custom_database")
#custom_analyzer = HEITT::HashAnalyzer.new(custom_db)


