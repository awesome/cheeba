# -*- ruby -*-

raise "cheeba requires Ruby version 1.8.7" unless RUBY_VERSION == "1.8.7"

gem 'rake', '0.8.7'
gem 'hoe', '1.8.2'
gem 'minitest', '>=1.3.1', '<=1.7.2'

require 'rubygems'
# raise "cheeba requires Gem version 1.6.2" unless Gem::VERSION == "1.6.2"
require 'rake'
require 'hoe'
require 'minitest/unit'
require File.join(File.dirname(__FILE__), 'lib/cheeba/version.rb')

Hoe.new('cheeba', Cheeba::VERSION) do |o|
  o.developer('So Awesome Man', 'callme@1800AWESO.ME')
end

# vim: syntax=ruby
