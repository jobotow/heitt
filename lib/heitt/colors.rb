
require 'set'
require 'colorize'
require 'io/console'


module HEITT

  def self.colorize(text, color, *styles)
    return text unless STDOUT.isatty #&& !(defined?(Flags) && Flags.no_color)

    colored = text.colorize(color)
    styles.each do |style|
      colored = colored.send(style)
    end
    colored
  end


  def self.header(title_word, center_align = true)
    terminal_width = terminal_width()
   
    padding = " " * ((terminal_width - title_word.length) / 2)
    border_padding = " " * ((terminal_width - title_word.length - 16) / 2)
    border = "=" * (title_word.length + 16)
    if center_align
      "#{border_padding}#{border}\n #{padding}#{title_word}\n#{border_padding}#{border}\n"
    else
      "#{border}\n#{title_word}\n#{border}\n"
    end  
  end


  def self.footer(foot_word, center_align = true)
    terminal_width = terminal_width()
    end_width = foot_word.length >= terminal_width ? foot_word.length / 3 : foot_word.length
  
    padding = " " * ((terminal_width - end_width) / 2)
    border = "=" * (terminal_width)
    if center_align
      "#{border}\n #{padding}#{foot_word}\n#{border}\n"
    else
      "#{border}\n#{foot_word}\n#{border}\n"
    end
  end

  private
  def terminal_width 
    IO.console.winsize[1] rescue 80
  end
end

#usage
 # puts "#{HEITT.colorize('[ERROR]', :red, :bold)} Invalid truncation index:
  #{HEITT.colorize('Negative indices not supported', :green)}"