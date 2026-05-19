require 'logger'
require 'colorize'

module HEITT
  module Logger
    @debug = false
    #LEVELS = { debug: 0, verbose: 1, info: 2, warn: 3, error: 4 }
    #@level = :warn 

    #def self.set_level(lvl)
    #  @level = lvl
    #end
    def self.enable_debug
      @debug = true
    end

    def self.disable_debug
      @debug = false
    end

    def self.debug_enabled?
      @debug
    end

    def self.debug(msg)
      log("[DEBUG] #{msg}", :cyan)
    end

    def self.warn(msg)
      log("[WARN] #{msg}", :yellow)
    end

    def self.error(msg)
      log("[ERROR] #{msg}", :red)
    end

    private
    def self.log(msg, color)
      return unless @debug
      $stderr.puts HEITT::Color.colorize(msg, color)
    end
  end


  module Color
    def self.colorize(text, color, *styles)
      return text unless STDOUT.isatty #&& !(defined?(Flags) && Flags.no_color)

      colored = text.colorize(color)
      styles.each do |style|
        colored = colored.send(style)
      end
      colored
    end
  end
  #private_constant :Color
end