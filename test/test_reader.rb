#!/usr/bin/env ruby -w

require 'rubygems'
require 'minitest/unit'
$: << 'lib' << 'test'
require 'cheeba/reader'
require 'cheeba/indicators'
require 'cheeba/defaults'
MiniTest::Unit.autorun

class TestReader < MiniTest::Unit::TestCase
  def setup
    @file_com = "test/files/comments.cash"
    @file_arr = "test/files/arrays.cash"
    @file_hsh = "test/files/hashes.cash"
    @file_mix = "test/files/mixed.cash"
    @file_mal = "test/files/malformed.cash"
    @file_bla = "test/files/blank.cash"
    @file_spl = "test/files/split.cash"
    opt   = Cheeba::Indicators.options
    @opt  = Cheeba::Defaults.options.merge(opt)
    @reader = Cheeba::Reader
  end

  def test_test_files_exists
    assert File.exists?(@file_com)
    assert File.exists?(@file_arr)
    assert File.exists?(@file_hsh)
    assert File.exists?(@file_mix)
    assert File.exists?(@file_mal)
    assert File.exists?(@file_bla)
    assert File.exists?(@file_spl)
  end
  
  def test_parse_string
    exp1 = {"awesome" => "dude"}
    exp2 = {1 => {"awesome" => "dude"}, :lst => {1 => "1"}}
    act1 = @reader.read("awesome: dude", @opt.merge({:list => false}))
    act2 = @reader.read("awesome: dude", @opt.merge({:list => true}))
    assert_equal exp1, act1
    assert_equal exp2, act2
  end

  def test_parse_empty_string_raise_emptystringerror
    assert_raises(Cheeba::Reader::EmptyInputError) {@reader.read("", @opt)}
  end
  
  def test_parse_blank_file_raise_emptyfileerror
    assert_raises(Cheeba::Reader::EmptyFileError) {@reader.read(@file_bla, @opt)}
  end

  def test_parse_blank_file_raise_invalidinputerror
    assert_raises(Cheeba::Reader::InvalidInputError) {@reader.read({}, @opt)}
  end

  def test_parse_split_raise_rootnodeerror
    assert_raises(Cheeba::Reader::Builder::RootNodeError) {
      @reader.read(@file_spl, @opt.merge({:list => true}))
    }
  end

  def test_parse_file_array
    exp1 = ["", 1, 2, [["", "awesome", "awesome"]], 4, 5, 6, [7, [8], "dude"], ""]
    exp2 = {1 => ["", 1, 2, [["", "awesome", "awesome"]], 4, 5, 6, [7, [8], "dude"], ""],
       :lst=> {
         1  => "1",
         2  => "1",
         3  => "1",
         4  => "1",
         5  => "1,3",
         6  => "1,3,0",
         7  => "1,3,0",
         8  => "1,3,0",
         9  => "1",
         10 => "1",
         11 => "1",
         12 => "1,7",
         13 => "1,7,1",
         14 => "1,7",
         15 => "1"}}
    act1 = @reader.read(@file_arr, @opt.merge({:list => false}))
    act2 = @reader.read(@file_arr, @opt.merge({:list => true}))
    assert_equal exp1, act1
    assert_equal exp2, act2
  end

  def test_parse_file_hash
    exp1 = {"grocery_list" => 
      {"meatsez" => 
        {1 => {"count" => 5, "model" => "Spam"},
         2 => {"count" => 1, "model" => "Log of ground beef"}},
       "beer" => {1 => {"count" => 1, "model" => "24 pack - Coors Lite"}},
       "cigarettes" => 
        {1 => {"count" => 2, "model" => "Carton - Basic Ultra Menthol Box 100"}},
       "other" => 
        {1 => {"count" => 2, "model" => "Economy-Size Pork & Beans"},
         2 => {"count" => 1, "model" => "Jumbo Miracle Whip"},
         3 => {"count" => 2, "model" => "White Wonder Bread"}}}}
    exp2 = {1  =>  {"grocery_list" => 
      {"meatsez" => 
        {1 => {"count" => 5, "model" => "Spam"},
         2 => {"count" => 1, "model" => "Log of ground beef"}},
       "beer" => {1 => {"count" => 1, "model" => "24 pack - Coors Lite"}},
       "cigarettes" => 
        {1 => {"count" => 2, "model" => "Carton - Basic Ultra Menthol Box 100"}},
       "other" => 
        {1 => {"count" => 2, "model" => "Economy-Size Pork & Beans"},
         2 => {"count" => 1, "model" => "Jumbo Miracle Whip"},
         3 => {"count" => 2, "model" => "White Wonder Bread"}}}},
       :lst => 
        {1 => "1,grocery_list",
         2 => "1,grocery_list,beer",
         3 => "1,grocery_list,beer,1",
         4 => "1,grocery_list,beer,1",
         5 => "1,grocery_list,beer,1",
         6 => "1,grocery_list,meatsez",
         7 => "1,grocery_list,meatsez,1",
         8 => "1,grocery_list,meatsez,1",
         9 => "1,grocery_list,meatsez,1",
         10 => "1,grocery_list,meatsez,2",
         11 => "1,grocery_list,meatsez,2",
         12 => "1,grocery_list,meatsez,2",
         13 => "1,grocery_list,cigarettes",
         14 => "1,grocery_list,cigarettes,1",
         15 => "1,grocery_list,cigarettes,1",
         16 => "1,grocery_list,cigarettes,1",
         17 => "1,grocery_list,other",
         18 => "1,grocery_list,other,1",
         19 => "1,grocery_list,other,1",
         20 => "1,grocery_list,other,1",
         21 => "1,grocery_list,other,2",
         22 => "1,grocery_list,other,2",
         23 => "1,grocery_list,other,2",
         24 => "1,grocery_list,other,3",
         25 => "1,grocery_list,other,3",
         26 => "1,grocery_list,other,3"}}
    act1 = @reader.read(@file_hsh, @opt.merge({:list  =>  false}))
    act2 = @reader.read(@file_hsh, @opt.merge({:list  =>  true}))
    assert_equal exp1, act1
    assert_equal exp2, act2
  end

  def test_parse_file_mixed
    exp1 = {1=>1,
      2 => ["", "one", "two", {5=>{6=>6, 7=>7}, 8=>{"dude"=>"dude"}}, ""],
      3 =>"awesome"}
    exp2 = {1=>
      {1=>1,
      2=>["", "one", "two", {5=>{6=>6, 7=>7}, 8=>{"dude"=>"dude"}}, ""],
      3=>"awesome"},
      :lst => {
        1 => "1",
        2 => "1,2",
        3 => "1,2",
        4 => "1,2",
        5 => "1,2",
        6 => "1,2,3,5",
        7 => "1,2,3,5",
        8 => "1,2,3,5",
        9 => "1,2,3,8",
        10 => "1,2,3,8",
        11 => "1,2",
        12 => "1"}}
    act1 = @reader.read(@file_mix, @opt.merge({:list => false}))
    act2 = @reader.read(@file_mix, @opt.merge({:list => true}))
    assert_equal exp1, act1
    assert_equal exp2, act2
  end

  def test_parse_file_comments
    exp1 = {1=>1, 2=>2, 3=>3, 4=>[1, 2, 3]}
    exp2 = {1=>{1=>1, 2=>2, 3=>3, 4=>[1, 2, 3]},
      :lst => {
        1 => "#COMMENT: dude",
        2 => "1",
        3 => "#COMMENT: awesome",
        4 => "1",
        5 => "#COMMENT: ",
        6 => "#COMMENT: camaro",
        7 => "#COMMENT: ",
        8 => "1",
        9 => "#COMMENT: #",
        10 => "#COMMENT: nice",
        11 => "#COMMENT: one",
        12 => "#COMMENT: bro!",
        13 => "#COMMENT: ",
        14 => "1,4",
        15 => "1,4",
        16 => "1,4",
        17 => "1,4"}}
    act1 = @reader.read(@file_com, @opt.merge({:list => false}))
    act2 = @reader.read(@file_com, @opt.merge({:list => true}))
    assert_equal exp1, act1
    assert_equal exp2, act2
  end

  def test_parse_file_malformed
    exp1 = {}
    exp2 = {
      1=>{}, 
      :lst => {
        1 => "#MALFORMED: 2341234", 
        2 => "#MALFORMED: awesome", 
        3 => "#MALFORMED: dude"}}
    act1 = @reader.read(@file_mal, @opt.merge({:list => false}))
    act2 = @reader.read(@file_mal, @opt.merge({:list => true}))
    assert_equal exp1, act1
    assert_equal exp2, act2
  end
end
