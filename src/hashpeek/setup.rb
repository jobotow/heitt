#This file is required to get HEITT identification and extraction database files to "/.heitt"

require 'fileutils'
#require 'yaml'

module HEITT
  class Database
    attr_accessor :heitt_dir, :current_hashdb_path, :current_extdb_path, :new_hashdb_path, :new_extdb_path

    def initialize()
      @heitt_dir = File.join(Dir.home, "./heitt")
      @current_hashdb_path = "hash_database.json"
      @current_extdb_path = "extract_database.json"  
      @new_hashdb_path = File.join(@heitt_dir, "hash_database.json")
      @new_extdb_path = File.join(@heitt_dir, "extract_database.json")
    end

    def load(file_name, custom_path)
      ensure_database_exists
      database = find_database_path(file_name, custom_path)
      load_database(database)
    end


    private
    def ensure_database_exists
      unless File.exist?(@new_hashdb_path) && File.exist?(@new_extdb_path)
        #move the ident and extract database to the "/.heitt" dir
        move_database_files
      else
        puts "Files already exists" #For testing
      end
    end

    def move_database_files
      FileUtils.mkdir_p(@heitt_dir) unless Dir.exist?(@heitt_dir) 
      #For testing,  I used "cp" instead of "mv"
      puts "Setting Up HEITT"
      puts "  Copying database files...."
      FileUtils.cp(@current_hashdb_path, @heitt_dir)
      FileUtils.cp(@current_extdb_path, @heitt_dir)  
      puts "  Copied database file to: #{@new_hashdb_path}"
      puts "  Copied extraction database file to: #{@new_extdb_path}"
    end

    def load_database(database, custom_database=nil)
      filepath = custom_database.nil? ? database : custom_database
      unless File.exist?(filepath)
        puts HEITT.colorize("[ERROR] Database file #{filepath} does not exist", :bold, :red)
        exit(1)
      end

      begin
        file_content = File.read(filepath)
        JSON.parse(file_content, symbolize_names: true)
      rescue JSON::ParserError => e
        puts HEITT.colorize("[ERROR] Invalid JSON in database file:", :bold, :red)
        puts "#{e.message}"
        exit(1)
      end
    end

    # For finding database path from any expected directory path
    def find_database_path(name, custom_path=nil)
      return custom_path if custom_path && File.exists?(custom_path)
      [
        ENV["HEITT_#{name.upcase}_DATABASE"], #Request database path from env
        File.join(Dir.home, ".heitt", "#{name}.json"), # Check hidden heitt directory 
        "#{name}.json", # check current directory
        "/usr/share/heitt/#{name}.json" # check /usr/share directory
      ].compact.find {|path| File.exist?(path)}
    end    
  end
end




#Usage
#HEITT::Setup.new.load