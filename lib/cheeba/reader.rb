require 'cheeba/reader/node'
require 'cheeba/reader/format'
require 'cheeba/reader/builder'
require 'cheeba/reader/parser'

module Cheeba
  module Reader
    class EmptyFileError < StandardError; end
    class EmptyInputError < StandardError; end
    class InvalidInputError < StandardError; end
    #
    # parses file or string into Ruby Array, or Hash
    #
    def self.read(input, options) 
      raise Cheeba::Reader::EmptyInputError if (input.is_a?(String) && input.strip.empty?)
      raise Cheeba::Reader::InvalidInputError unless (input.is_a?(String) or input.is_a?(File))
      input = IO.readlines(input) if File.exists?(input)
      raise Cheeba::Reader::EmptyFileError if input.empty?
      hash = {}
      lineno = 0
      input.each {|line|
        parsed_hash    = Cheeba::Reader::Parser.parse(line, options, (lineno += 1)) 
        formatted_hash = Cheeba::Reader::Format.format(parsed_hash) 
        Cheeba::Reader::Builder.build(hash, formatted_hash)
      }
      hash.delete(:adr) 
      case
      when options[:list]: hash
      when !options[:list]: hash.delete(:lst) && (hash.length == 1) ? hash[1] : hash
      end
    end
  end
end
