
require 'set'
require 'colorize'

module HEITT

  def self.colorize(text, color, *styles)
    return text unless STDOUT.isatty #&& !(defined?(Flags) && Flags.no_color)

    colored = text.colorize(color)
    styles.each do |style|
      colored = colored.send(style)
    end
    colored
  end
end

#usage
 # puts "#{HEITT.colorize('[ERROR]', :red, :bold)} Invalid truncation index:
  #{HEITT.colorize('Negative indices not supported', :green)}"