require 'cheeba/writer/builder'

module Cheeba
  module Writer
    class EmptyFilenameError < StandardError; end
    class EmptyInputError < StandardError; end
    class InvalidInputError < StandardError; end
    class InvalidFilenameError < StandardError; end
    #
    # array, hash, or string to array of lines of .cash file
    #
    def self.build(object, options)
      raise Cheeba::Writer::EmptyInputError if (object.is_a?(String) && object.strip.empty?)
      raise Cheeba::Writer::InvalidInputError unless (object.is_a?(String) or object.is_a?(Array) or object.is_a?(Hash))
      Cheeba::Writer::Builder.build([], object, options)
    end

    #
    # array, hash, or string to file
    #
    def self.write(object, filename, options)
      filename = "#{ENV['HOME']}/#{File.basename(filename.to_s)}" if (filename =~ /^~/)
      raise Cheeba::Writer::EmptyInputError if (object.is_a?(String) && object.strip.empty?)
      raise Cheeba::Writer::InvalidInputError unless (object.is_a?(String) or object.is_a?(Array) or object.is_a?(Hash))
      raise Cheeba::Writer::EmptyFilenameError if File.basename(filename.to_s).strip.empty?
      raise Cheeba::Writer::InvalidFilenameError unless File.exists?(File.dirname(filename))
      File.open(filename, "w") do |file| 
        self.build(object, options).each {|line|
          file.print("#{line}\n")
        }
      end 
      filename
    end
    
    #
    # write a cheeba dotfile to home dir
    #
    def self.dotfile(options, home)
      filename = "#{home.chomp("/")}/.cheeba"
      new_name = nil
      if File.exists?(filename) 
        new_name = "#{filename}.#{Time.now.strftime("%Y%m%d%H%M%S")}"
        File.rename(filename, new_name) 
      end
      self.write(options, filename, Cheeba::Indicators.options)
      new_name ? new_name : filename
    end
  end
end
