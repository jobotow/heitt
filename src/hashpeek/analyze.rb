require 'json'
require 'set'
#require_relative '../cli_flag'
require_relative 'colors'
require_relative 'outfmt'

module HEITT

  class StreamGroupResults
    attr_accessor :groups, :total_hashes
  
    def initialize(groups, total_hashes)
      @groups = groups
      @total_hashes = total_hashes
    end

    def tree_format
      HEITT.tree_group_format(self)
    end

    def json_format
      HEITT.json_group_format(self)
    end
  end
  private_constant :StreamGroupResults

  class AnalysisResult
    attr_accessor :hash, :algorithms, :found
    def initialize(hash, algorithms, found)
      @hash = hash
      @algorithms = algorithms 
      @found = found
    end

    def tree_format
      HEITT.tree_format(self)
    end

    def json_format
      HEITT.json_format(self)
    end
  end
  private_constant :AnalysisResult

 
  class HashAlgo
    attr_accessor :name, :description, :hashcat, :john, :characteristics, :common_sources, :context, :notes, :limitations, :extended

    def initialize(attributes = {})
      @name = attributes[:name]
      @description = attributes[:description] || ""
      @hashcat = attributes[:hashcat] || "--"
      @john = attributes[:john] || "--"
      #release only when verbose mode
      @characteristics = attributes[:characteristics] || ""
      #@common_sources = attributes[:common_sources] || []
      #@context = attributes[:context] || []
      @notes = attributes[:notes] || []
      #@limitations = attributes[:limitations] || []
      @extended = attributes[:extended] || false
    end
  end
  private_constant :HashAlgo


  class HashDatabase
    attr_accessor :database, :compiled_patterns
    def initialize(filepath)
      @database = load_database(filepath)
    end

    

    def find_algorithms(hash)
      matched = []
      @database.each do |entry|
        pattern = Regexp.new(entry[:regex])
        if hash =~ pattern
          matched.concat(entry[:modes].map { |algo| HashAlgo.new(algo)})
        end
      end
      matched.any? ? [matched, true] : [[], false]
      #[[], false]
    end
    
    private
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

  private_constant :HashDatabase

    
  class Identifier
    attr_accessor :database, :hash_counts, :ident_results, :hash_lists, :total_hashes

    def initialize(database = "hash_database.json")
      @database = HashDatabase.new(database)
      @hash_counts = {}
      @ident_results = {}
      @hash_lists = {}
      @total_hashes = 0
    end

    def identify(hash)
      algorithms, found = @database.find_algorithms(hash.strip)
      AnalysisResult.new(hash.strip, algorithms, found)
    end

    def <<(hash)
      stream_identify(hash)
      self
    end

    def batch_identify(hashes, &block)
      hashes.each do |hash|
        result = identify(hash)
        block.call(result) if block
        stream_identify(hash)
      end
      finalize
    end

    def finalize
      get_stream_results
    end


    #Convenience funciton
    def analyze_hash(hash, database_path = "hash_database.json")
      database  = HashDatabase.new(database_path)
      analyzer = HashAnalyzer.new(database)
      analyzer.identify(hash)
    end



    

    
    private 
    def stream_identify(hash)
      return if hash.empty?

      @total_hashes += 1
      ident_result = identify(hash)

      if ident_result.algorithms.any?
        algorithm_name = ident_result.algorithms.first.name
        if @hash_counts.key?(algorithm_name)
          @hash_counts[algorithm_name] += 1
          @hash_lists[algorithm_name] << hash
        else
          @hash_counts[algorithm_name] = 1
          @ident_results[algorithm_name] = ident_result
          @hash_lists[algorithm_name] = [hash]
        end
      end
    end


    def get_stream_results
      groups = []
      
      if @total_hashes > 0 
        @hash_counts.each do |algorithm_name, count|
          
          percent = ((count.to_f / @total_hashes.to_f) * 100).round(2)
          ident_result = @ident_results[algorithm_name]

          groups << {
            identified_result: ident_result, 
            count: count, 
            percent: percent, 
            hashes: @hash_lists[algorithm_name]
          }
        end
      end
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

analyze = HEITT::Identifier.new()
hashes = ["a95c9b6ab0e338f225f5f7595c7674b7","b1946ac92492d2347c6235b4d2611184", "5891b5b522d5df086d0ff0b110fbd9d21bb4fc7163af34d08286a2e846f6be03", "e73b7fc75f15461894e98ce26c773e9e"]
puts analyze.batch_identify(hashes).tree_format

#puts "STREAM: #{ident.get_stream_results}"
#analyzer.stream_identify("hash1")
#analyzer.stream_identify("hash2")
#result = analyze.get_stream_results

#Custom database
#custom_db = HEITT::HashDatabase.new("custom_database")
#custom_analyzer = HEITT::HashAnalyzer.new(custom_db)


