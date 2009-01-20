#!/usr/bin/env ruby -w

require 'rubygems'
require 'minitest/unit'
$: << 'lib' << 'test'
require 'cheeba'
MiniTest::Unit.autorun

class TestCheeba < MiniTest::Unit::TestCase
  def setup
    @files  = "#{File.dirname(__FILE__)}/files"
    @test = "#{@files}/test.cash"
    @opt = Cheeba::Defaults.options.merge(Cheeba::Indicators.options)
    @hom = ENV['HOME']
    @dot = "#{@hom}/.cheeba"
    @hsh = {
      "grocery_list" => {
        "meatsez" => {
          1 => {"count"=>5, "model"=>"Spam"},
          2 => {"count"=>1, "model"=>"Log of ground beef"}},
        "beer"=>{1=>{"count"=>1, "model"=>"24 pack - Coors Lite"}},
        "cigarettes" => {
          1 => {"count"=>2, "model"=>"Carton - Basic Ultra Menthol Box 100"}},
        "other" => {
          1 => {"count"=>2, "model"=>"Economy-Size Pork & Beans"},
          2 => {"count"=>1, "model"=>"Jumbo Miracle Whip"},
          3 => {"count"=>2, "model"=>"White Wonder Bread"}}}}
    @exp = 
      ["grocery_list:",
       "  meatsez:",
       "    1:",
       "      count: 5",
       "      model: Spam",
       "    2:",
       "      count: 1",
       "      model: Log of ground beef",
       "  cigarettes:",
       "    1:",
       "      count: 2",
       "      model: Carton - Basic Ultra Menthol Box 100",
       "  beer:",
       "    1:",
       "      count: 1",
       "      model: 24 pack - Coors Lite",
       "  other:",
       "    1:",
       "      count: 2",
       "      model: Economy-Size Pork & Beans",
       "    2:",
       "      count: 1",
       "      model: Jumbo Miracle Whip",
       "    3:",
       "      count: 2",
       "      model: White Wonder Bread"]
  end

  def test_read_hash
    act = Cheeba.read("#{@files}/hashes.cash")    
    assert_equal @hsh, act
  end

  def test_read_hash_options_symbolize_keys
    hsh = ":awesome: dude"
    exp = {:awesome => "dude"}
    act = Cheeba.read(hsh, {:symbolize_keys => true})    
    assert_equal exp, act
  end

  def test_read_string
    str = IO.read("#{@files}/hashes.cash")
    act = Cheeba.read(str)
    assert_equal @hsh, act
  end

  def test_parse_hash
    act = Cheeba.parse(@hsh)
    assert_equal @exp, act
  end

  def test_write
    File.delete(@test) if File.exists?(@test)
    refute(File.exists?(@test), "dude!")
    Cheeba.write(@hsh, @test)
    act = (IO.readlines(@test).map {|x| x.chomp})
    assert(File.exists?(@test))
    assert_equal @exp, act
    File.delete(@test) 
  end

  def test_dotfile
    File.delete(@dot) if File.exists?(@dot) 
    refute(File.exists?(@dot), "dude!")
    Cheeba.dotfile 
    assert(File.exists?(@dot)) 
    exp_keys = Cheeba::Defaults.options
    act_keys = Cheeba::Reader.read(@dot, @opt.merge({:symbolize_keys => true}))
    assert_equal exp_keys, act_keys
    File.delete(@dot) 
  end

  def test_dotfile_exists
    len = Dir.entries(@hom).length
    mv_by_test = (File.exists?(@dot) ? "#{@dot}.mv_by_test" : "")
    File.rename(@dot, mv_by_test) unless mv_by_test.empty?
    refute(File.exists?(@dot), "dude!")
    dot = Cheeba.dotfile
    assert File.exists?(@dot) 
    assert File.exists?(dot)
    assert_equal len, (Dir.entries(@hom).length - 1)
    File.delete(@dot) if File.exists?(@dot) 
    File.delete(dot) if File.exists?(dot) 
    refute(File.exists?(@dot), "dude!")
    refute(File.exists?(dot), "dude!")
    File.rename(mv_by_test, @dot) if File.exists?(mv_by_test)
  end

  def test_read_raise_on_empty_string
    assert_raises(Cheeba::Reader::EmptyInputError) {Cheeba.read("")} 
  end
end
