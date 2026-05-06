require 'set'
#require_relative '../cli_flag'
#require_relative 'hash_db.json' #will use a different db file
require_relative 'colors'
require 'json'


#colorToggle = not flags.noColor and stdout.isatty()
module HEITT
  class Extractor
    attr_accessor :current_line, :database

    def initialize(filepath = "hash_database.json")
      @database = load_database(filepath)
      @current_line = 0
      @extracted_hashes = []
    end

    def scan_file(filepath, delimiter: nil, index: nil)
      unless File.exist?(filepath)
        puts HEITT.colorize("[ERROR] File #{filepath} does not exist", :bold, :red)
        return []
      end

      content = File.read(filepath)

      if delimiter && index
        result = parse_field(content, delimiter, index)
      else
        result = regex_extract(content)
      end
      @extracted_hashes.concat(result)
      result.uniq
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

    def increment_line
      @current_line += 1
    end

    def parse_field(content, delimiter, index)
      found_hashes = []
      content.each_line do |line|
        increment_line
        next if line.strip.empty?

        fields = line.split(delimiter)

        if index < fields.length
          potential_hash = fields[index].strip
        
          found_hashes << potential_hash
        else
          found_hashes << regex_extract(line)
        end
      end
      found_hashes 
    end



    def regex_extract(content)
      found_hashes = []
      @database.each do |pattern_str, _|
        pattern = Regexp.new(pattern_str.to_s)
        matches = content.scan(pattern)
        found_hashes.concat(matches)
      end
      found_hashes.uniq
    end
  end
end


#usage code
#extractor = HEITT::Extractor.new
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
#puts extractor.scan_file("hashes.txt", delimiter: ":", index: 5)
#puts extractor.scan_text("root:$6$abc123.....:18000:0:99999", delimiter: ":", index: 5)



 



    