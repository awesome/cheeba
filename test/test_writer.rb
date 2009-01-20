#!/usr/bin/env ruby -w

require 'rubygems'
require 'minitest/unit'
$: << 'lib' << 'test'
require 'cheeba/writer'
require 'cheeba/indicators'
MiniTest::Unit.autorun

class TestWriter < MiniTest::Unit::TestCase
  def setup
    @writer = Cheeba::Writer
    @opt    = Cheeba::Indicators.options
    @files  = "#{File.dirname(__FILE__)}/files"
    @test   = "#{@files}/test.cash"
  end

  def test_build_hash_one_node_depth
    hsh = {1 => 1, 2 => 2, "awesome" => "awesome"}
    exp = ["awesome: awesome", "1: 1", "2: 2"]
    act = @writer.build(hsh, @opt)
    assert_equal exp, act
  end

  def test_build_hash_multi_node_depth
    hsh = {1 => {"a" => {2 => {"b" => {"awesome" => "awesome"}}}}, 3 => "dude"}
    exp = ["1:", "  a:", "    2:", "      b:", "        awesome: awesome", "3: dude"]
    act = @writer.build(hsh, @opt)
    assert_equal exp, act
  end

  def test_build_array_one_node_depth
    arr = [1, 2, 3, "awesome"]
    exp = ["- 1", "- 2", "- 3", "- awesome"]
    act = @writer.build(arr, @opt)
    assert_equal exp, act
  end

  def test_build_array_multi_node_depth
    arr = [1, 2, 3, [["awesome", 4, 5], 6]]
    exp = ["- 1", "- 2", "- 3", "    - awesome", 
      "    - 4", "    - 5", "  - 6"]
    act = @writer.build(arr, @opt)
    assert_equal exp, act
  end

  def test_build_array_multi_node_depth_yaml
    arr = [1, 2, 3, [["awesome", 4, 5], 6]]
    exp = ["- 1", "- 2", "- 3", "-", "  -", "    - awesome", 
      "    - 4", "    - 5", "  - 6"]
    opt = @opt.merge({:yaml => true})
    act = @writer.build(arr, opt)
    assert_equal exp, act
  end

  def test_build_mixed_multi_node_depth
    arr = {1 => 2, 3 => {"awesome" => [["awesome", 4, 5], 6], 7 => 8}}
    exp = ["1: 2", "3:", "  awesome:", "      - awesome", 
      "      - 4", "      - 5", "    - 6", "  7: 8"] 
    act = @writer.build(arr, @opt)
    assert_equal exp, act
  end
  
  def test_build_mixed_multi_node_depth_yaml
    arr = {1 => 2, 3 => {"awesome" => [["awesome", 4, 5], 6], 7 => 8}}
    exp = ["1: 2", "3:", "  awesome:", "    -", "      - awesome", 
      "      - 4", "      - 5", "    - 6", "  7: 8"]
    opt = @opt.merge({:yaml => true})
    act = @writer.build(arr, opt)
    assert_equal exp, act
  end
  
  def test_build_mixed_multi_node_depth_docs
    arr = {1 => {1 => 2}, 2 => {3 => {"awesome" => [["awesome", 4, 5], 6], 7 => 8}}}
    exp = ["---", "1: 2", "---", "3:", "  awesome:", "      - awesome", 
      "      - 4", "      - 5", "    - 6", "  7: 8"] 
    opt = @opt.merge({:docs => true})
    act = @writer.build(arr, opt)
    assert_equal exp, act
  end
  
  def test_build_string
    str = "1\n2\n3\nawesome" 
    exp = ["- 1", "- 2", "- 3", "- awesome"]
    act = @writer.build(str, @opt)
    assert_equal exp, act
  end

  def test_write
    hsh = {1 => 1, 2 => 2, 3 => 3}
    exp = "1: 1\n2: 2\n3: 3\n"
    File.delete(@test) if File.exist?(@test)
    refute(File.exists?(@test), "dude!")
    @writer.write(hsh, @test, @opt)
    act = IO.read(@test)
    assert(File.exists?(@test))
    assert_equal exp, act
    File.delete(@test) 
  end

  def test_write_raise_invalidfilenameerror
    assert_raises(Cheeba::Writer::InvalidFilenameError) {@writer.write([1,2,3], "/#####/beer.cash", @opt)}
  end

  def test_write_to_home
    home = "~/write_to_home_test"
    hsh = {1 => 1, 2 => 2, 3 => 3}
    exp = "1: 1\n2: 2\n3: 3\n"
    File.delete(home) if File.exist?(home)
    refute(File.exists?(home), "dude!")
    fizzle = @writer.write(hsh, home, @opt)
    assert(File.exists?(fizzle))
    act = IO.read(fizzle)
    assert_equal exp, act
    File.delete(fizzle) 
  end

  def test_write_raise_emptyfilenameerror_on_nil
    assert_raises(Cheeba::Writer::EmptyFilenameError) {@writer.write([1,2,3], nil, @opt)}
  end

  def test_write_raise_emptyfilenameerror
    assert_raises(Cheeba::Writer::EmptyFilenameError) {@writer.write([1,2,3], "", @opt)}
  end

  def test_write_raise_invalidinputerror
    assert_raises(Cheeba::Writer::InvalidInputError) {@writer.write(5, @test, @opt)}
  end

  def test_write_raise_emptyinputerror
    assert_raises(Cheeba::Writer::EmptyInputError) {@writer.write("", @test, @opt)}
  end
end
