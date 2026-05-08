require 'optparse'
require_relative 'styles.rb'
require_relative 'config'
require_relative 'registry'

module Digistry
  class CLI
    attr_accessor :version, :github, :command , :options, :update_opts, :info_opts, :search_opts

    def initialize()
      @config = Digistry::Config.new.load
      #@command = ARGV[0..-1]
      @version = "0.1.0"
      @github = "https://github.com/digistry-org/digistry"
      @options = {}
      @update_opts = {}
      @info_opts = {}
      @search_opts = {}
    end

    #[] is for empty array
    #{} is for empty hash/dictionary/key-value store

  
    def show_help
      result = ""
      result += header("digistry  #{@version} - Language agnostic library discovery tool")
      result += "\nDig up libraries the internet forgot\n\n"
      result += "Usage: digistry COMMANDS [OPTIONS]\n"
      result += "COMMANDS:\n"
      result += "    search <name||tag>                 Search for packages in the registry by name or tag\n"
      result += "    info <name>                        Show detailed information about a package\n"
      result += "    update                             Update local registry\n"
      result += "    config                             Open or edit configuration file"
      #result += "    clean                              Remove local index for a language"
      #result += "    vendor <name>                      Clone a library into ./vendor/\n\n"

      result += "GENERAL OPTIONS:\n"
      result += "    -h, --help                         Show this help message.\n"
      result += "    -v, --version                      Show version information.\n\n"
      
      result +=  "EXAMPLES:\n"
      result +=  "  digistry search graphics\n"
      result +=  "  digistry info jamgine\n"
      result +=  "  digistry update\n"
      #result +=  "  digistry vendor jamgine\n\n"

      result +=  "For more: #{@github}\n"
      result +=  footer("end of help information")
    end
 

    def run
      command = ARGV.shift
      case command
      when 'info'
        cmd_info
      when 'search'
        cmd_search
      when 'update'
        cmd_update
      when 'config'
        cmd_config 
      when "help", "-h", "--help", nil
        puts show_help
      when '-v', '--version'
        puts "digistry #{@version}"
      else
        puts "Unknown command: #{@command}"
        show_help
        exit 1
      end
    end

    private
    def cmd_update
      options = parse_update_options
      options[:lang] ||= @config['default_language']

      puts "Updating Index for: #{options[:lang].capitalize}..."
      Digistry::Registry.new(@config, options).update_registry
    end



    def cmd_search
      term = ARGV.shift
      options = parse_search_options
      options[:lang] ||= @config['default_language']

      if term.nil?
        puts "Error: search term required"
        puts "Example  digistry search graphics --lang zig"
        exit 1
      end

      registry = Digistry::Registry.new(@config, options)
      index = registry.load_registry

      results = index['packages'].select do |pkg|
        pkg['name'].downcase.include?(term.downcase) || pkg['description']&.downcase&.include?(term.downcase)
      end

      limit = options[:limit]
      results.first(limit).each do |pkg|
        last_commit = Time.parse(pkg['last_commit'])
        days_ago = (Time.now - last_commit) / 86400
        status = days_ago < 180 ? "active" : "stalled" 
        status = "archived" if pkg['archived']
        puts "\e[36m#{pkg['name']}\e[0m"
        puts "    #{pkg['description'] || 'No description'}"
        puts "    ⭐ #{pkg['stars']} | #{pkg['license'] || 'No license' } | #{status} (#{parse_days(last_commit)})"
        puts "    #{pkg['url']}\n\n"
      end
      
      if results.size > limit
        puts "  ... and #{results.size - limit} more results"
      elsif results.empty?
        puts "No results found for '#{term}' in #{options[:lang]}"
      end
    end

    def cmd_info
      name = ARGV.shift
      options = parse_info_options
      options[:lang] ||= @config['default_language']

      if options[:lang].nil?
        puts "Error: --lang is required"
        exit 1
      end

      registry = Digistry::Registry.new(@config, options)
      index = registry.load_registry
      
      pkg = index['packages'].find { |p| p['name'].downcase == name.downcase}

      if pkg.nil?
        puts "Library '#{name}' not found in #{options[:lang]} index"
        puts "Run: digistry update --lang #{options[:lang]}"
        exit 1
      end

      if options[:json]
        puts JSON.pretty_generate(pkg)
      else
        puts "name: #{pkg['name']}"
        puts "url: #{pkg['url']}"
        puts "author: #{pkg['author']}"
        puts "license: #{pkg['license']}"
        puts "stars: #{pkg['stars']}"
        puts "language: #{pkg['language']}"
        puts "added: #{pkg['added_at']}"
        puts ""
        puts "description:"
        puts "    #{pkg['description'] || 'No description'}"
      end
    end

    def cmd_config
      config = Digistry::Config.new
      config.ensure_config_exists

      system("#{config.editor} #{Digistry::Config.get_config_file}")
    end



    def parse_update_options
      options = {}
      OptionParser.new do |opts|
        opts.separator header("Digistry Update - Update local registry")
        opts.banner = ""
        opts.separator "Usage: digistry update [OPTIONS]"
        opts.separator ""
        opts.separator "OPTIONS:"
        opts.on("-t", "--tag <name>", String, "Search by Github topic (user-assigned)")
        opts.on("-s", "--star <range||number>", Integer, "Filter libraries by star count.")
        #opts.on("-a", "--auto", "Smart pagination using star ranges.")
        opts.on("-k", "--keyword <word>", String, "Search by text in README/description.")
        opts.on("-l", "--lang <name>", String, "Search by programming language.")
        opts.separator ""
        opts.separator "EXAMPLES:"
        opts.separator "  digistry update --lang odin --tag gamedev"
        opts.separator "  digistry update --lang nim --keyword color"
        opts.separator "  digistry update --lang nim --tag graphics -s 9"
        opts.separator "  digistry update --lang zig --keyword wifi -s 0-10\n\n"
        opts.separator footer("end of help information")
      end.parse!(into: options)
      #parser.parse!(ARGV)
      options
      #@update_opts
    end
 


    def parse_info_options
      options = {}
      OptionParser.new do |opts|
        opts.separator header("Digistry  Info - Detailed information about packages")
        opts.separator "Usage: digistry info <PACKAGE> [OPTIONS]"
        opts.banner = ""
        opts.separator ""
        opts.separator "ARGUMENT:"
        opts.separator("<PACKAGE>                            Package to show detailed info about.")
        opts.separator ""
        opts.separator "OPTIONS:"
        opts.on("-j", "--json", "Output as JSON")
        opts.on("-l", "--lang <name>", String, "Search by programming language.")
        opts.separator ""
        opts.separator "EXAMPLES:"
        opts.separator "  digistry info jamgine -l odin"
        opts.separator "  digistry info odin-ini-parser -l nim --json\n\n"
        opts.separator footer("end of help information")
      end.parse!(into: options)
      options
    end
 

    def parse_search_options
      options = {limit: 20}
      OptionParser.new do |opts|
        opts.separator header("Digistry  Search - Search for packages in the registry")
        opts.banner = "" 
        opts.separator "Usage: digistry search <TERM> [OPTIONS]"
        opts.separator ""
        opts.separator "ARGUMENT:"
        opts.separator("<TERM>                            Term to search for")
        opts.separator ""
        opts.separator "OPTIONS:"
        opts.on("-n", "--limit <number>", Integer, "Max results to show (default: 20)")
        opts.on("-s", "--star <range||number>", String, "Filter libraries by star count.")
        opts.on("-l", "--lang <name>", String, "Search by programming language.")
        opts.separator ""
        opts.separator "EXAMPLES:"
        opts.separator "  digistry search graphics --lang odin -s 0-10"
        opts.separator "  digistry search parser -l nim -n 10 -s 5\n\n"
        opts.separator footer("end of help information")
      end.parse!(into: options)
      options
    end

    private
    def parse_days(last_commit)
      days_ago = ((Time.now - last_commit) / 86400).to_i
      weeks_ago = days_ago/7 
      months_ago = days_ago/30 
      if days_ago < 7
        return "#{days_ago} days ago"
      elsif days_ago < 120
        return "#{weeks_ago} weeks ago"
    
      elsif days_ago < 365  
        return "#{months_ago} months ago"
      else
        years_ago = days_ago/365
        return "#{years_ago} years ago"
      end
    end
  end
end