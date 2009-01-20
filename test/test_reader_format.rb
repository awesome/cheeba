#!/usr/bin/env ruby -w

require 'rubygems'
require 'minitest/unit'
$: << 'lib' << 'test'
require 'cheeba/reader/format'
require 'cheeba/defaults'
MiniTest::Unit.autorun

class TestReaderFormat < MiniTest::Unit::TestCase
  def setup
    @format = Cheeba::Reader::Format
    @opt = {}
    Cheeba::Defaults.options.each_key {|k| @opt[k] = false}
    @phs    = { :msg => nil, 
                :spc => nil, 
                :key => nil, 
                :val => nil, 
                :ask => nil, 
                :asv => nil,
                :opt => @opt}
  end

  #
  # parsed_hash => formatted_hash
  #
  def test_format_basic
    phs = @phs.merge({:key => "1", :val => "1", :opt => @opt})
    act = @format.format(phs) 
    assert_equal Hash, act.class
  end
  
  def test_adjust_options
    phs1 = {:opt => {:auto_sym => true}}
    phs2 = {:opt => {:auto_sym => false}}
    @format.adjust_options(phs1)
    @format.adjust_options(phs2)
    assert phs1[:opt][:auto_sym_keys]
    assert phs1[:opt][:auto_sym_vals]
    assert !phs2[:opt][:auto_sym_keys]
    assert !phs2[:opt][:auto_sym_vals]
  end

  #
  # strip different things
  #
  def test_strip
    key = "    awesome   "
    val = "    awesome   "
    opt1 = {:strip => true}
    opt2 = @opt.clone 
    act_phs1 = @phs.merge({:key => key, :val => val, :opt => opt1})
    act_phs2 = @phs.merge({:key => key, :val => val, :opt => opt2})
    exp_key1 = "awesome"
    exp_val1 = "awesome"
    exp_key2 = key
    exp_val2 = val
    @format.format(act_phs1)
    @format.format(act_phs2)
    assert_equal exp_key1, act_phs1[:key] 
    assert_equal exp_val1, act_phs1[:val] 
    assert_equal exp_key2, act_phs2[:key] 
    assert_equal exp_val2, act_phs2[:val] 
  end

  def test_strip_keys
    key = "    awesome   "
    opt1 = {:strip_keys => true}
    opt2 = @opt.clone 
    act_phs1 = @phs.merge({:key => key, :opt => opt1})
    act_phs2 = @phs.merge({:key => key, :opt => opt2})
    exp_key1 = "awesome"
    exp_key2 = key
    @format.format(act_phs1)
    @format.format(act_phs2)
    assert_equal exp_key1, act_phs1[:key] 
    assert_equal exp_key2, act_phs2[:key] 
  end

  def test_strip_vals
    val = "    awesome   "
    opt1 = {:strip_vals => true}
    opt2 = @opt.clone 
    act_phs1 = @phs.merge({:val => val, :opt => opt1})
    act_phs2 = @phs.merge({:val => val, :opt => opt2})
    exp_val1 = "awesome"
    exp_val2 = val
    @format.format(act_phs1)
    @format.format(act_phs2)
    assert_equal exp_val1, act_phs1[:val] 
    assert_equal exp_val2, act_phs2[:val] 
  end

  #
  # convert true, false in strings
  #
  def test_true_keys
    opt1 = @opt.clone
    opt2 = @opt.merge({:auto_true_keys => true})
    opt3 = @opt.merge({:auto_true => true})
    opt4 = @opt.clone
    opt5 = @opt.merge({:auto_true_keys => true})
    opt6 = @opt.merge({:auto_true => true})
    act_phs1 = @phs.merge({:key => "true", :opt => opt1})
    act_phs2 = @phs.merge({:key => "true", :opt => opt2})
    act_phs3 = @phs.merge({:key => "true", :opt => opt3})
    act_phs4 = @phs.merge({:key => "false", :opt => opt4})
    act_phs5 = @phs.merge({:key => "false", :opt => opt5})
    act_phs6 = @phs.merge({:key => "false", :opt => opt6})
    @format.key_to_true(act_phs1)
    @format.key_to_true(act_phs2)
    @format.key_to_true(act_phs3)
    @format.key_to_true(act_phs4)
    @format.key_to_true(act_phs5)
    @format.key_to_true(act_phs6)
    assert_equal "true", act_phs1[:key]
    assert_equal true, act_phs2[:key]
    assert_equal true, act_phs3[:key]
    assert_equal "false", act_phs4[:key]
    assert_equal false, act_phs5[:key]
    assert_equal false, act_phs6[:key]
  end

  def test_true_vals
    opt1 = @opt.clone
    opt2 = @opt.merge({:auto_true_vals => true})
    opt3 = @opt.merge({:auto_true => true})
    opt4 = @opt.clone
    opt5 = @opt.merge({:auto_true_vals => true})
    opt6 = @opt.merge({:auto_true => true})
    act_phs1 = @phs.merge({:val => "true", :opt => opt1})
    act_phs2 = @phs.merge({:val => "true", :opt => opt2})
    act_phs3 = @phs.merge({:val => "true", :opt => opt3})
    act_phs4 = @phs.merge({:val => "false", :opt => opt4})
    act_phs5 = @phs.merge({:val => "false", :opt => opt5})
    act_phs6 = @phs.merge({:val => "false", :opt => opt6})
    @format.val_to_true(act_phs1)
    @format.val_to_true(act_phs2)
    @format.val_to_true(act_phs3)
    @format.val_to_true(act_phs4)
    @format.val_to_true(act_phs5)
    @format.val_to_true(act_phs6)
    assert_equal "true", act_phs1[:val]
    assert_equal true, act_phs2[:val]
    assert_equal true, act_phs3[:val]
    assert_equal "false", act_phs4[:val]
    assert_equal false, act_phs5[:val]
    assert_equal false, act_phs6[:val]
  end

  #
  # symbolize key
  #
  def test_key_to_sym
    exp_key1 = "awesome"
    exp_key2 = "awesome".to_sym
    opt1 = @opt.clone
    opt2 = @opt.merge({:auto_sym_keys => true})
    opt3 = @opt.merge({:symbolize => true})
    opt4 = @opt.merge({:symbolize_keys => true})
    act_phs1 = @phs.merge({:key => "awesome", :opt => opt1})
    act_phs2 = @phs.merge({:key => "awesome", :opt => opt2})
    act_phs3 = @phs.merge({:key => "awesome", :opt => opt3})
    act_phs4 = @phs.merge({:key => "awesome", :opt => opt4})
    @format.key_to_sym(act_phs1)
    @format.key_to_sym(act_phs2)
    @format.key_to_sym(act_phs3)
    @format.key_to_sym(act_phs4)
    assert_equal exp_key1, act_phs1[:key]
    assert_equal exp_key1, act_phs2[:key]
    assert_equal exp_key2, act_phs3[:key]
    assert_equal exp_key2, act_phs4[:key]
  end
  
  def test_key_to_sym_number_in_string
    exp_key1 = "411"
    exp_key2 = "411".to_sym
    opt1 = @opt.clone
    opt2 = @opt.merge({:auto_sym_keys => true})
    opt3 = @opt.merge({:symbolize => true})
    opt4 = @opt.merge({:symbolize_keys => true})
    act_phs1 = @phs.merge({:key => "411", :opt => opt1})
    act_phs2 = @phs.merge({:key => "411", :opt => opt2})
    act_phs3 = @phs.merge({:key => "411", :opt => opt3})
    act_phs4 = @phs.merge({:key => "411", :opt => opt4})
    @format.key_to_sym(act_phs1)
    @format.key_to_sym(act_phs2)
    @format.key_to_sym(act_phs3)
    @format.key_to_sym(act_phs4)
    assert_equal exp_key1, act_phs1[:key]
    assert_equal exp_key1, act_phs2[:key]
    assert_equal exp_key2, act_phs3[:key]
    assert_equal exp_key2, act_phs4[:key]
  end
  
  #
  # symbolize val
  #
  def test_val_to_sym
    exp_val1 = "awesome"
    exp_val2 = "awesome".to_sym
    opt1 = @opt.clone
    opt2 = @opt.merge({:auto_sym_vals => true})
    opt3 = @opt.merge({:symbolize => true})
    opt4 = @opt.merge({:symbolize_vals => true})
    act_phs1 = @phs.merge({:val => "awesome", :opt => opt1})
    act_phs2 = @phs.merge({:val => "awesome", :opt => opt2})
    act_phs3 = @phs.merge({:val => "awesome", :opt => opt3})
    act_phs4 = @phs.merge({:val => "awesome", :opt => opt4})
    @format.val_to_sym(act_phs1)
    @format.val_to_sym(act_phs2)
    @format.val_to_sym(act_phs3)
    @format.val_to_sym(act_phs4)
    assert_equal exp_val1, act_phs1[:val]
    assert_equal exp_val1, act_phs2[:val]
    assert_equal exp_val2, act_phs3[:val]
    assert_equal exp_val2, act_phs4[:val]
  end
  
  def test_val_to_sym_number_in_string
    exp_val1 = "411"
    exp_val2 = "411".to_sym
    opt1 = @opt.clone
    opt2 = @opt.merge({:auto_sym_vals => true})
    opt3 = @opt.merge({:symbolize => true})
    opt4 = @opt.merge({:symbolize_vals => true})
    act_phs1 = @phs.merge({:val => "411", :opt => opt1})
    act_phs2 = @phs.merge({:val => "411", :opt => opt2})
    act_phs3 = @phs.merge({:val => "411", :opt => opt3})
    act_phs4 = @phs.merge({:val => "411", :opt => opt4})
    @format.val_to_sym(act_phs1)
    @format.val_to_sym(act_phs2)
    @format.val_to_sym(act_phs3)
    @format.val_to_sym(act_phs4)
    assert_equal exp_val1, act_phs1[:val]
    assert_equal exp_val1, act_phs2[:val]
    assert_equal exp_val2, act_phs3[:val]
    assert_equal exp_val2, act_phs4[:val]
  end

  #
  # key is parsed as string, try to_i
  #
  def test_key_to_int_string
    exp_key1 = "411"
    exp_key2 = 411
    exp_key3 = "411".to_sym
    opt1 = @opt.clone
    opt2 = @opt.merge({:int => true})
    opt3 = @opt.merge({:int_keys => true})
    opt4 = @opt.merge({:int => true})
    opt5 = @opt.merge({:int_keys => true})
    act_phs1 = @phs.merge({:key => "411", :opt => opt1})
    act_phs2 = @phs.merge({:key => "411", :opt => opt2})
    act_phs3 = @phs.merge({:key => "411", :opt => opt3})
    act_phs4 = @phs.merge({:key => "411".to_sym, :opt => opt4})
    act_phs5 = @phs.merge({:key => "411".to_sym, :opt => opt5})
    @format.key_to_int(act_phs1)
    @format.key_to_int(act_phs2)
    @format.key_to_int(act_phs3)
    @format.key_to_int(act_phs4)
    @format.key_to_int(act_phs5)
    assert_equal exp_key1, act_phs1[:key]
    assert_equal exp_key2, act_phs2[:key]
    assert_equal exp_key2, act_phs3[:key]
    assert_equal exp_key3, act_phs4[:key]
    assert_equal exp_key3, act_phs5[:key]
  end

  #
  # val is parsed as string, try to_i
  #
  def test_val_to_int
    exp_val1 = "411"
    exp_val2 = 411
    exp_val3 = "411".to_sym
    opt1 = @opt.clone
    opt2 = @opt.merge({:int => true})
    opt3 = @opt.merge({:int_vals => true})
    opt4 = @opt.merge({:int => true})
    opt5 = @opt.merge({:int_vals => true})
    act_phs1 = @phs.merge({:val => "411", :opt => opt1})
    act_phs2 = @phs.merge({:val => "411", :opt => opt2})
    act_phs3 = @phs.merge({:val => "411", :opt => opt3})
    act_phs4 = @phs.merge({:val => "411".to_sym, :opt => opt4})
    act_phs5 = @phs.merge({:val => "411".to_sym, :opt => opt5})
    @format.val_to_int(act_phs1)
    @format.val_to_int(act_phs2)
    @format.val_to_int(act_phs3)
    @format.val_to_int(act_phs4)
    @format.val_to_int(act_phs5)
    assert_equal exp_val1, act_phs1[:val]
    assert_equal exp_val2, act_phs2[:val]
    assert_equal exp_val2, act_phs3[:val]
    assert_equal exp_val3, act_phs4[:val]
    assert_equal exp_val3, act_phs5[:val]
  end
  
  #
  # returns Int if String is convertable
  #
  def test_string_to_int
    str1 = ""
    str2 = "awesome"
    str3 = "123awesome"
    str4 = "123"
    exp1 = ""
    exp2 = "awesome"
    exp3 = "123awesome"
    exp4 = 123
    act1 = @format.string_to_int(str1) 
    act2 = @format.string_to_int(str2) 
    act3 = @format.string_to_int(str3) 
    act4 = @format.string_to_int(str4) 
  end
end
