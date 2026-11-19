#require 'json'
#require 'set'
#require 'strscan'
#require 'logger'
#require 'colorize'
require_relative 'heitt/profiles'
require_relative 'heitt/decoder'
require_relative 'heitt/database'
require_relative 'heitt/analyzer'
require_relative 'heitt/scanner'
require_relative 'heitt/grouper'
require_relative 'heitt/formatter'
require_relative 'heitt/version'

# Library should be used as 
# ident = HEITT.new(input, "*options) which identifies snd groups 
# ident.json or ident.tree
module HEITT
  attr_accessor: :
results = HEITT::Scanner.scan("auth.log")
groups = HEITT::Grouper.group(results)
puts HEITT::Formatter.tree(groups)
# OR for json
puts HEITT::Formatter.json(groups)
