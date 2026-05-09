require 'set'
require 'strscan'
require_relative 'colors'
require_relative 'setup'
require_relative 'scoring'
require_relative 'analyze'  # FOR Testing
require 'json'

module HEITT
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
      scan_text(content, delimiter: delimiter, index: index)
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
        @extracted_hashes.uniq
    end


    
    private
    
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
      
      @database.each do |entry|
        regex = get_regex(entry)
        modes = get_modes(entry)
        next unless regex && modes && !modes.empty? 

        pattern = Regexp.new(regex)
        scanner = StringScanner.new(content)
        entry_contexts = entry[:contexts] || []


        while scanner.scan_until(pattern)
          matched = scanner.matched
          offset = scanner.pos - matched.length

          #Get hash prefix (prefix detection)
          delim_prefix = scorer.get_prefix(content, offset)

          classified = scorer.collect_scored_matches(modes, delim_prefix, context_scores)
          #puts "HASH: #{matched}    |    CLASSIFIED: #{classified}"

          found_hashes << {
            hash: matched,
            possible_types: classified
          }
        end
      end
      found_hashes
    end

    def parse_field(content, delimiter, index)
      found_hashes = []
      content.each_line do |line|
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

ident = HEITT::Identifier.new
#field parsing mode
extracted = extractor.scan_file("hashes.txt")
#puts "EXTRACTED: #{extracted}"
extracted.each do |ext|
  #ext[:possible_types].each do |pos|
 #   puts "NAME: #{pos[:name]}"
  #end
  ident << ext
end
#ident << extracted
result = ident.finalize
puts "RESULTS: #{result.tree_format}"
#puts extractor.scan_text("root:$6$abc123.....:18000:0:99999", delimiter: ":", index: 5)



 



    