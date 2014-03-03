# -*- ruby -*-

raise "cheeba requires Ruby version 1.8.7" unless RUBY_VERSION == "1.8.7"
require 'rubygems'
gem 'hoe', '1.8.2'
require 'hoe'
require File.join(File.dirname(__FILE__), 'lib/cheeba/version.rb')
gem 'minitest', '>=1.3.1', '<=1.7.2'
require 'minitest/unit'

Hoe.new('cheeba', Cheeba::VERSION) do |o|
  o.developer('So Awesome Man', 'callme@1800AWESO.ME')
end

# vim: syntax=ruby
