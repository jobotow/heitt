require 'set'
require 'strscan'
#require_relative '../cli_flag'
#require_relative 'hash_db.json' #will use a different db file
require_relative 'colors'
require_relative 'setup'
require_relative 'dbase'
require_relative 'scoring'
require 'json'


#colorToggle = not flags.noColor and stdout.isatty()
module HEITT
  #class ExtractionResult
   # attr_accessor :results, :total_hashes
    #attr_accessor :hash, :possible_types, :confidence

    #def initialize(results)
      #@results = results
     # @total_hashes = results.size
      #@hash = data[:hash]
      #@possible_types = data[:possible_types]
      #@confidence = data[:confidence]
    #end

    #def json_format
     # JSON.pretty_generate(results)
    #end
  #end

  class Extractor
    attr_accessor :database

    def initialize(custom_database=nil)
      @database = HEITT::Database.new.load("extract_database", custom_database)
      @extracted_hashes = []
    end

    def scan_text(text, delimiter: nil, index: nil)
      if delimiter && index
        result = parse_field(text, delimiter, index)
      else
        result = regex_extract(text)
      end
      @extracted_hashes.concat(result)
      result.uniq
    end



    def scan_file(filepath, delimiter: nil, index: nil)
      unless File.exist?(filepath)
        puts HEITT.colorize("[ERROR] File #{filepath} does not exist", :bold, :red)
        return []
      end

      content = File.read(filepath)

      #if delimiter && index
      #  result = parse_field(content, delimiter, index)
      #else
      #  result = regex_extract(content)#@database.query(content)
      #end
      #result = 
      scan_text(content, delimiter: delimiter, index: index)
      #@extracted_hashes.concat(result)
      #ExtractionResult.new(result.uniq)
      #result#.uniq
    end




    def <<(input)
      if File.exist?(input) 
        scan_file(input)
      else
        scan_text(input)
      end
      self
    end

    def finalize
      #ExtractionResult(
        @extracted_hashes.uniq#)
    end


    
    private
    #def increment_line
     # @current_line += 1
    #end

    def get_regex(entry)
      entry[:extract_regex] || entry[:regex] || entry[:pattern] || entry[:regexp]
    end

    def get_modes(entry)
      entry[:modes] || entry[:algorithms] || entry[:hashes] || 
      entry[:candidates] || entry[:types] || entry[:hashtypes]
    end
    def regex_extract(content)
      found_hashes = []
      content_lower = content.downcase

      #first extract documnt level context
      scorer = HEITT::Scorer.new(@database)
      context_scores = scorer.analyze(content_lower)

      #puts "CONTEXT SCORES: #{context_scores}\n\n\n"
      #keyword_counts = HEITT::ContextScorer.extract_keywords(content_lower, @database) #Extraction class

      #Prescore algorithms based on document context
      #algorithm_scores = HEITT::ContextScorer.score_algorithms(keyword_counts) #Scoring class
      
      @database.each do |entry|
        regex = get_regex(entry)
        modes = get_modes(entry)
        #puts "ALL_MODE: #{modes}"
        next unless regex && modes && !modes.empty? #entry_has_extractable_data?(entry)

        pattern = Regexp.new(regex)
        scanner = StringScanner.new(content)
        entry_contexts = entry[:contexts] || []
        #modes = get_modes(entry)

        while scanner.scan_until(pattern)
          matched = scanner.matched
          offset = scanner.pos - matched.length

          #Get prefix before hash on same line (prefix detection)
          delim_prefix = scorer.get_prefix(content, offset)
          #puts "DELMITED PREFIX: #{delim_prefix}"

          #score and identify the hash based on modes
          # classify_hash should call get_line_prefix()
          classified = scorer.classify_hash(modes, delim_prefix, context_scores) #Sorting algorithm

          found_hashes << {
            hash: matched,
            #offset: offset,
            #prefix: classified[:prefix],
            possible_types: classified
            #name: classified[:name],
            #confidence: classified[:confidence],
            #label: classified[:label],
            #score: classified[:score].class
          }
        end
      end
      found_hashes.uniq { |h| h[:hash]}
    end

    def parse_field(content, delimiter, index)
      found_hashes = []
      content.each_line do |line|
        #increment_line #uncomment when extration data are needed
        next if line.strip.empty?

        fields = line.split(delimiter)

        if index < fields.length
          potential_hash = fields[index].strip
        
          found_hashes << potential_hash
        else
          found_hashes.concat(@database.query(line))
        end
      end
      found_hashes 
    end
  end
end


#usage code
extractor = HEITT::Extractor.new
#custom database
#extractor = HEITT::Extractor.new("custom_database.json")

#accept both hashes and files 
#extractor << "31eb" << "deff" << "hashes.txt"
#puts extractor.finalize

#regex scan 
#extractor.scan_file("auth-log")
#puts extractor.scan_text("User login with hash: 31ebdfce8b77ac49d7f5506dd1495830")
#puts extractor.scan_text("User login with hash: 31eb")

#field parsing mode
puts extractor.scan_file("hashes.txt")
#puts extractor.scan_text("root:$6$abc123.....:18000:0:99999", delimiter: ":", index: 5)



 



    