require 'optparse'
require_relative 'colors.rb'

module HEITT
  class Config
    attr_accessor :inputs, :delimiter, :index, :extended, :output, :json, :database, :extractdb

    def initialize
      @inputs = []
      @delimiter = ""
      @index = 0
      @extended = false
      @output = ""
      @json = false
      @database = ""
      @extractdb = ""
    end

    Version = "0.1.0"
    Github = "https://github.com/ph4mished/yadirb"

    def parse_arguments!
      parser = OptionParser.new do |opts|   
        opts.program_name = "heitt"
        opts.separator HEITT.header("HEITT  #{@version} - Hash Extraction, Identification & Triage Tool")
        opts.separator ""
        opts.separator "\nExtract and identify hashes from any input: files, stdin, or text."
        opts.separator "Input may be hash string, a file, path or '-' for stdin"
        opts.separator ""
        opts.separator "Usage: heitt [<INPUT(S)>] [OPTIONS]"
        opts.version = "v#{Version} by jobotow (#{Github})"
        opts.separator ""
        opts.separator "ARGUMENTS:"
        opts.separator "    [<INPUT(S)>]                     List of hashes or files for identification(one or more)"
        opts.separator ""
        opts.separator "GENERAL OPTIONS:"
        opts.separator "    -h, --help                       Show this help message and exit"
        opts.separator "    -v, --version                    Show version information"
        opts.separator ""

        opts.separator "EXTRACTION OPTIONS:"
        opts.on("-d", "--delimiter DELIM", String, "Field delimiter for structured files")
        opts.on("-i", "--index NUM", Integer, "Field index to extract")
  
        opts.separator ""
        opts.separator "COMMON OPTIONS:"
        opts.on("-e", "--extended", "Show extended candidates")
        opts.on("-o", "--output FILEPATH", String, "File to write output to")
        opts.on("-j", "--json","Outputs in json format")

        opts.separator ""
        opts.separator "DATABASE OPTIONS:"
        opts.on("-D", "--database FILEPATH", String, "Use custom identification database")
        opts.on("-E", "--extractdb FILEPATH", String, "Use custom extraction database")

        opts.separator ""
        opts.separator "EXAMPLES:"
        opts.separator "  # Identification"
        opts.separator "    heitt b1946ac92492d2347c6235b4d2611184"
        opts.separator "    heitt my_hashes.txt"
        opts.separator ""
        opts.separator ""
        opts.separator "NOTES:"
        opts.separator "  -JSON format is default when output is redirected or piped."
        opts.separator HEITT.footer("end of help information")
      end
      parser.parse!(into: self)

      @inputs = ARGV[0..-1].empty? ? $stdin.read : ARGV[0..-1]
      self
    end

    def to_h
      {
        inputs: @inputs,
        delimiter: @delimiter,
        index: @index,
        extended: @extended,
        output: @output,
        json: @json,
        database: @database,
        extractdb: @extractdb, 
      }
    end
  end
end
