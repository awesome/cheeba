#!/usr/bin/env ruby -w

require 'rubygems'
require 'minitest/unit'
$: << 'lib' << 'test'
require 'cheeba/writer/builder'
require 'cheeba/indicators'
MiniTest::Unit.autorun

class TestWriterBuilder < MiniTest::Unit::TestCase
  def setup
    @builder = Cheeba::Writer::Builder
    @opt = Cheeba::Indicators.options
  end

  def test_build_string
    act_str = []
    str = "awesome\nawesome\nawesome"
    exp_str = ["- awesome", "- awesome", "- awesome"]
    @builder.build(act_str, str, @opt)
    assert_equal exp_str, act_str
  end

  def test_sym_to_str
    exp1 = [":awesome", ":dude"]
    exp2 = [":awesome", "dude"]
    exp3 = ["awesome", ":dude"]
    exp4 = ["awesome", "dude"]
    exp5 = [":awesome", nil]
    exp6 = ["awesome", nil]
    act1 = @builder.sym_to_str("awesome".to_sym, "dude".to_sym)
    act2 = @builder.sym_to_str("awesome".to_sym, "dude")
    act3 = @builder.sym_to_str("awesome", "dude".to_sym)
    act4 = @builder.sym_to_str("awesome", "dude")
    act5 = @builder.sym_to_str("awesome".to_sym)
    act6 = @builder.sym_to_str("awesome")
    assert_equal act1, exp1
    assert_equal act2, exp2
    assert_equal act3, exp3
    assert_equal act4, exp4
    assert_equal act5, exp5
    assert_equal act6, exp6
  end

  def test_build_hash
    act_hsh = []
    hsh = {"awesome" => "awesome"}
    exp_hsh = ["awesome: awesome"]
    @builder.build(act_hsh, hsh, @opt)
    assert_equal exp_hsh, act_hsh
  end

  def test_build_hash_symbols
    act_hsh = []
    hsh = {:awesome => :awesome}
    exp_hsh = [":awesome: :awesome"]
    @builder.build(act_hsh, hsh, @opt)
    assert_equal exp_hsh, act_hsh
  end

  def test_build_array
    act_arr = []
    arr = ["awesome", "awesome", "awesome"]
    exp_arr = ["- awesome", "- awesome", "- awesome"]
    @builder.build(act_arr, arr, @opt)
    assert_equal exp_arr, act_arr
  end

  def test_string_to_array
    act = []
    str = "awesome\nawesome\nawesome"
    exp = ["- awesome", "- awesome", "- awesome"]
    @builder.string_to_array(act, str, @opt, "  ")
    assert_equal exp, act
  end

  def test_hash_to_array
    act = []
    hsh = {1 => 1, 2 => "awesome", "3" => "awesome"}
    exp = ["1: 1", "2: awesome", "3: awesome"]
    @builder.hash_to_array(act, hsh, @opt, "  ")
    assert_equal exp, act
  end

  def test_hash_to_array_doc
    act = []
    hsh = {1 => {1 => 1, 2 => "awesome", "3" => "awesome"}, 2 => {2 => 2}}
    exp = ["---", "1: 1", "2: awesome", "3: awesome", "---", "2: 2"]
    opt = @opt.merge({:docs => true})
    @builder.hash_to_array(act, hsh, opt, "  ")
    assert_equal exp, act
  end

  def test_hash_to_array_nested
    act = []
    hsh = {1 => 1, 2 => "awesome", "3" => {1 => 1, 2 => 2, 3 => 3}}
    exp = ["1: 1", "2: awesome", "3:", "  1: 1", "  2: 2", "  3: 3"]
    @builder.hash_to_array(act, hsh, @opt, "  ")
    assert_equal exp, act
  end

  def test_array_to_lines
    act = []
    arr = [1, 2, "awesome"]
    exp = ["- 1", "- 2", "- awesome"]
    @builder.array_to_lines(act, arr, @opt, "  ")
    assert_equal exp, act
  end

  def test_array_to_lines_nested
    act = []
    arr = [1, 2, [1, 2, [3]]]
    exp = ["- 1", "- 2", "  - 1", "  - 2", "    - 3"]
    @builder.array_to_lines(act, arr, @opt, "  ")
    assert_equal exp, act
  end

  def test_array_to_lines_nested_yaml
    act = []
    arr = [1, 2, [1, 2, [3]]]
    exp = ["- 1", "- 2", "-", "  - 1", "  - 2", "  -", "    - 3"]
    opt = @opt.merge({:yaml => true})
    @builder.array_to_lines(act, arr, opt, "  ")
    assert_equal exp, act
  end

  def test_hash_to_lines
    act = []
    hsh = {1 => 1, 2 => "awesome", "3" => "awesome"}
    exp = ["1: 1", "2: awesome", "3: awesome"]
    @builder.hash_to_lines(act, hsh, hsh.keys, @opt, "  ")
    assert_equal exp, act
  end

  def test_hash_to_lines_nested_hash
    act = []
    hsh = {1 => 1, 2 => "awesome", "3" => {1 => 1, 2 => 2}}
    exp = ["1: 1", "2: awesome", "3:", "  1: 1", "  2: 2"]
    @builder.hash_to_lines(act, hsh, hsh.keys, @opt, "  ")
    assert_equal exp, act
  end

  def test_hash_to_lines_nested_array
    act = []
    hsh = {1 => 1, 2 => "awesome", "3" => [1, 2, 3]}
    exp = ["1: 1", "2: awesome", "3:", "  - 1", "  - 2", "  - 3"]
    @builder.hash_to_lines(act, hsh, hsh.keys, @opt, "  ")
    assert_equal exp, act
  end
end
