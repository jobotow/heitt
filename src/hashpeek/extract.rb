require 'set'
#require_relative '../cli_flag'
#require_relative 'hash_db.json' #will use a different db file
require_relative 'color'


#colorToggle = not flags.noColor and stdout.isatty()
class FieldParser
  attr_accessor :current_line

  def initialize
    @current_line = 0
  end

  def increment_line
    @current_line += 1
  end

  def parse_field(hash_line, delim, index)
    split_word = hash_line.split(delim)

    if index < 0
      puts "#{HEITT.colorize('[ERROR]', :red, :bold)} Invalid truncation index: #{HEITT.colorize('Negative indices not supported', :green)}"
      exit(0)
    end

    if index < split_word.length
      return [split_word[index], nil]
    else
      err_descript = "Not enough fields for truncating {#{index+1}} with delimiter '#{delim}"
      error = {
        status: "error",
        message: err_descript,
        field: split_word.length,
        line: @current_line,
        content: hash_line
      }
      return ["", error]
    end
  end
end

def parse_ignore(ignorable_char)
  if ignorable_char.include?(',')
    return ignorable_char.split(',')
  end
  [ignorable_char]
end

def ignore?(hash_line, ignorable_char)
  parse_ignore(ignorable_char).each do |ignore|
    return true if hash_line.start_with?(ignore)
  end
  false
end

def parse_truncate(trunc_input)
  val_split = trunc_input.split
  index = val_split[0].strip.gsub(/[{}]/, '').to_i
  delim = val_split[1].strip.gsub(/`/, '')
  [index-1, delim]
end


def extract_hashed(input)
  found_hashes = []
  HASH_DATABASE.each do |pattern_str|
    pattern = Regexp.new(pattern_str)
    matches = input.scan(pattern)
    found_hashes.concat(matches)
  end
  found_hashes
end
