#!/usr/bin/env ruby -w

require 'rubygems'
require 'minitest/unit'
$: << 'lib' << 'test'
require 'cheeba/reader/node'
require 'cheeba/reader/parser'
require 'cheeba/indicators'
MiniTest::Unit.autorun

class TestReaderParser < MiniTest::Unit::TestCase
  def setup
    @parser = Cheeba::Reader::Parser
    @opt    = Cheeba::Indicators.options
  end

  def test_parser_module
    assert_kind_of Module, @parser
  end
  
  def test_parse_raise_indenterror
    lin1 = " 7:7"
    spc1 = 1
    idt1 = 2
    num1 = 88
    assert_raises(Cheeba::Reader::Parser::IndentError) {
      @parser.check_indent(lin1, spc1, idt1, num1)
    }
  end

  def test_check_indent_no_raise_indenterror
    lin1 = "  7:7"
    spc1 = 2
    idt1 = 2
    num1 = 88
    assert_nil @parser.check_indent(lin1, spc1, idt1, num1)
  end

  def test_parse_comment
    line = "#dude"
    phs = @parser.parse(line, @opt, 77)
    exp_msg = "com".to_sym
    exp_spc = 0
    exp_key = ""
    exp_val = "dude"
    exp_ask = nil
    exp_asv = nil
    exp_opt = @opt
    assert_equal exp_msg, phs[:msg] 
    assert_equal exp_spc, phs[:spc]
    assert_equal exp_key, phs[:key]
    assert_equal exp_val, phs[:val]
    assert_equal exp_ask, phs[:ask] 
    assert_equal exp_asv, phs[:asv]
    assert_equal exp_opt, phs[:opt]
  end

  # parsed line => [msg, spc, key, val, ask, asv, opt]
  def test_results_to_hash
    results = [1, "  ", "3", "4", 5, 6]
    phs     = @parser.results_to_hash(results, 7)
    exp_msg = 1
    exp_spc = 2
    exp_key = "3"
    exp_val = "4" 
    exp_ask = 5 
    exp_asv = 6
    exp_opt = 7
    assert_equal exp_msg, phs[:msg] 
    assert_equal exp_spc, phs[:spc]
    assert_equal exp_key, phs[:key]
    assert_equal exp_val, phs[:val]
    assert_equal exp_ask, phs[:ask] 
    assert_equal exp_asv, phs[:asv] 
    assert_equal exp_opt, phs[:opt]
  end

  def test_parse_line_malformed
    line = "awesome"
    phs = @parser.parse_line(line, @opt) 
    assert_equal :mal, phs[0]
    assert_equal "awesome", phs[3]
  end

  def test_parse_line_blank
    line1 = "  "
    line2 = ""
    exp_phs1 = @parser.parse_line(line1, @opt) 
    exp_phs2 = @parser.parse_line(line2, @opt) 
    assert_equal :bla, exp_phs1[0]
    assert_equal :bla, exp_phs2[0]
  end

  def test_parse_line_comment
    line1 = "  #awesome"
    line2 = "# dude"
    line3 = "###beer"
    line4 = "    #   camaro"
    exp_phs1 = @parser.parse_line(line1, @opt) 
    exp_phs2 = @parser.parse_line(line2, @opt) 
    exp_phs3 = @parser.parse_line(line3, @opt) 
    exp_phs4 = @parser.parse_line(line4, @opt) 
    assert_equal :com, exp_phs1[0]
    assert_equal :com, exp_phs2[0]
    assert_equal :com, exp_phs3[0]
    assert_equal :com, exp_phs4[0]
    assert_equal "awesome", exp_phs1.flatten[3]
    assert_equal "dude",    exp_phs2.flatten[3]
    assert_equal "##beer",  exp_phs3.flatten[3]
    assert_equal "camaro",  exp_phs4.flatten[3]
  end

  def test_parse_line_array
    line1 = "- awesome"
    line2 = "  -dude"
    line3 = "     -- beer"
    line4 = "    -     #camaro"
    exp_phs1 = @parser.parse_line(line1, @opt) 
    exp_phs2 = @parser.parse_line(line2, @opt) 
    exp_phs3 = @parser.parse_line(line3, @opt) 
    exp_phs4 = @parser.parse_line(line4, @opt) 
    assert_equal :arr, exp_phs1[0]
    assert_equal :arr, exp_phs2[0]
    assert_equal :arr, exp_phs3[0]
    assert_equal :arr, exp_phs4[0]
    assert_equal "",        exp_phs1.flatten[1]
    assert_equal "  ",      exp_phs2.flatten[1]
    assert_equal "     ",   exp_phs3.flatten[1]
    assert_equal "    ",    exp_phs4.flatten[1]
    assert_equal "awesome", exp_phs1.flatten[3]
    assert_equal "dude",    exp_phs2.flatten[3]
    assert_equal "- beer",  exp_phs3.flatten[3]
    assert_equal "#camaro", exp_phs4.flatten[3]
  end

  def test_parse_line_hashkey
    line1 = "awesome:"
    line2 = "  dude :"
    line3 = "     :beer:"
    line4 = '    "camaro":'
    exp_phs1 = @parser.parse_line(line1, @opt) 
    exp_phs2 = @parser.parse_line(line2, @opt) 
    exp_phs3 = @parser.parse_line(line3, @opt) 
    exp_phs4 = @parser.parse_line(line4, @opt) 
    assert_equal :hky, exp_phs1[0]
    assert_equal :mal, exp_phs2[0]
    assert_equal :hky, exp_phs3[0]
    assert_equal :hky, exp_phs4[0]
    assert_equal "",        exp_phs1.flatten[1]
    assert_equal "     ",   exp_phs3.flatten[1]
    assert_equal "    ",    exp_phs4.flatten[1]
    assert_equal "awesome",   exp_phs1.flatten[2]
    assert_equal ":beer",      exp_phs3.flatten[2]
    assert_equal '"camaro"',  exp_phs4.flatten[2]
    assert_equal nil,   exp_phs1.flatten[4]
    assert_equal true,  exp_phs3.flatten[4]
    assert_equal nil,   exp_phs4.flatten[4]
  end

  def test_parse_line_hashpair
    line1 = "awesome:dude"
    line2 = "  :dude::fekja"
    line3 = "     :beer:coke"
    line4 = '    "camaro"::firebird'
    exp_phs1 = @parser.parse_line(line1, @opt) 
    exp_phs2 = @parser.parse_line(line2, @opt) 
    exp_phs3 = @parser.parse_line(line3, @opt) 
    exp_phs4 = @parser.parse_line(line4, @opt) 
    assert_equal :hpr, exp_phs1[0]
    assert_equal :hpr, exp_phs2[0]
    assert_equal :hpr, exp_phs3[0]
    assert_equal :hpr, exp_phs4[0]
    assert_equal "",        exp_phs1.flatten[1]
    assert_equal "  ",      exp_phs2.flatten[1]
    assert_equal "     ",   exp_phs3.flatten[1]
    assert_equal "    ",    exp_phs4.flatten[1]
    assert_equal "awesome",   exp_phs1.flatten[2]
    assert_equal ":dude",     exp_phs2.flatten[2]
    assert_equal ":beer",     exp_phs3.flatten[2]
    assert_equal '"camaro"',  exp_phs4.flatten[2]
    assert_equal nil,   exp_phs1.flatten[4]
    assert_equal true,  exp_phs2.flatten[4]
    assert_equal true,  exp_phs3.flatten[4]
    assert_equal nil,   exp_phs4.flatten[4]
    assert_equal nil,   exp_phs1.flatten[5]
    assert_equal true,  exp_phs2.flatten[5]
    assert_equal nil,   exp_phs3.flatten[5]
    assert_equal true,  exp_phs4.flatten[5]
  end
end
