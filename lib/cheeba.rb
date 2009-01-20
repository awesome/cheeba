require 'cheeba/version'
require 'cheeba/reader'
require 'cheeba/writer'
require 'cheeba/indicators'
require 'cheeba/defaults'

module Cheeba
  DOTFILE = "#{ENV['HOME']}/.cheeba"
  #
  # File to Hash or Array
  #
  def self.read(input, options = {})
    Cheeba::Reader.read(input, self.options(options))
  end
 
  #
  # Hash or Array to .cash Array
  #
  def self.parse(object, options = {})
    Cheeba::Writer.build(object, self.options(options))
  end
  
  #
  # Hash or Array to .cash-file, e.g. filename.cash
  #
  def self.write(object, filename, options = {})
    Cheeba::Writer.write(object, filename, self.options(options))
  end

  #
  # writes a .cheeba file HOME, merges with options if :dot is true 
  #
  def self.dotfile(home = ENV['HOME'])
    Cheeba::Writer.dotfile(Cheeba::Defaults.options, home)
  end

  private
  
  #
  # options
  #
  def self.options(options = {})
    opt = Cheeba::Defaults.options.merge(Cheeba::Indicators.options.merge(options))
    dot_opt = File.exists?(DOTFILE) ? Cheeba::Reader.read(DOTFILE, opt.merge({:symbolize_keys => true})) : nil 
    unless opt[:dot]
      opt = opt.merge(dot_opt) if (dot_opt && dot_opt[:dot])
    end
    opt
  end
end
