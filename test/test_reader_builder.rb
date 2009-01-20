#!/usr/bin/env ruby -w

require 'rubygems'
require 'minitest/unit'
$: << 'lib' << 'test'
require 'cheeba/reader/builder'
MiniTest::Unit.autorun

class TestReaderBuilder < MiniTest::Unit::TestCase
  def setup
    @builder = Cheeba::Reader::Builder   
    @phash = {  :msg => nil, 
                :spc => nil, 
                :key => nil, 
                :val => nil, 
                :ask => false, 
                :asv => false, 
                :opt => {:indent => 2}}
    @dcs = @phash.merge({:msg => :dcs})
    @dct = @phash.merge({:msg => :dct})
    @hpr = @phash.merge({:msg => :hpr})
    @hky = @phash.merge({:msg => :hky})
    @arr = @phash.merge({:msg => :arr})
    @mal = @phash.merge({:msg => :mal})
  end

  ##
  # build
  #
  def test_build_module
    assert_kind_of Module, @builder
  end
  
  def test_build_array_raise_rootnodeerror
    hsh = {1 =>{"k1" => "awesome"}, :lst => {1 => "k1"}, :adr => [1,"k1"]} 
    val = "dude"
    phs = @arr.merge({:val => val, :spc => 0})
    assert_raises(Cheeba::Reader::Builder::RootNodeError) {@builder.build(hsh, phs)}
  end
  
  def test_build_array_with_zero_indent
    hsh = {} 
    val = "awesome"
    phs = @arr.merge({:val => val, :spc => 0})
    @builder.build(hsh, phs)
    assert_equal(["awesome"], hsh[1])
  end
  
  def test_build_array_into_hashkey
    hsh = {:adr => [1, "k1"], 1 => {"k1" => {}}, :lst =>{}}
    exp = {"k1" => ["awesome"]}
    val = "awesome"
    phs = @arr.merge({:val => val, :spc => 2})
    @builder.build(hsh, phs) 
    assert_equal exp, hsh[1]
  end

  def test_build_add_blank
    hsh = {:adr => [1], 1 => {}, :lst => {}}
    exp_lst1 = {1 => "#BLANK"}
    exp_lst2 = {1 => "#BLANK", 2 => "#BLANK"}
    @builder.build(hsh, {:msg => :bla}) 
    assert_equal exp_lst1, hsh[:lst]  
    @builder.build(hsh, {:msg => :bla}) 
    assert_equal exp_lst2, hsh[:lst]
  end

  def test_build_malformed
    hsh = {:adr => [1], 1 => {}, :lst => {}}
    exp_lst1 = {1 => "#BLANK"}
    exp_lst2 = {1 => "#BLANK", 2 => "#BLANK"}
    @builder.build(hsh, {:msg => :bla}) 
    assert_equal exp_lst1, hsh[:lst]  
    @builder.build(hsh, {:msg => :bla}) 
    assert_equal exp_lst2, hsh[:lst]
  end

  def test_build_array_into_array
    hsh = {:adr => [1, "k1"], 1 => {"k1" => [1,2]}, :lst =>{}}
    val = "awesome"
    phs = @arr.merge({:val => val, :spc => 4})
    @builder.build(hsh, phs) 
    exp_hsh = {"k1" => [1,2,["awesome"]]}
    exp_adr = [1, "k1", 2] 
    assert_equal exp_hsh, hsh[1]  
    assert_equal exp_adr, hsh[:adr]
  end

  def test_build_hashpair_into_array
    hsh = {:adr => [1, 0], 1 => [["awesome"]], :lst =>{}}
    phs = @hpr.merge({:key => "dude", :val => "fekja", :spc => 2})
    @builder.build(hsh, phs) 
    exp_hsh = [["awesome", {"dude" => "fekja"}]]
    exp_adr = [1, 0]
    assert_equal exp_hsh, hsh[1]
    assert_equal exp_adr, hsh[:adr]
  end

  def test_build_hashkey_into_array
    hsh = {:adr => [1, 0], 1 => [["awesome"]], :lst =>{}}
    phs = @hky.merge({:key => "dude", :spc => 2})
    @builder.build(hsh, phs) 
    exp_hsh = [["awesome", {"dude" => {}}]]
    exp_adr = [1, 0, 1, "dude"]
    assert_equal exp_hsh, hsh[1]
    assert_equal exp_adr, hsh[:adr]
  end
  
  def test_cur
    hsh1 = {:adr => [], :lst => {}, 1=>[7]}
    hsh2 = {:adr => [], :lst => {}, 1=>[7], 2=>[8]}
    exp_hsh1 = [7]
    exp_hsh2 = [8]
    act_hsh1 = @builder.cur(hsh1)
    act_hsh2 = @builder.cur(hsh2)
    assert_equal exp_hsh1, act_hsh1
    assert_equal exp_hsh2, act_hsh2
  end

  def test_doc_new
    exp1 = {:adr => [1], :lst => {}, 1=>{}}
    exp2 = {:adr => [2], :lst => {}, 1=>{}, 2=>{}}
    hsh = {}
    @builder.doc_new(hsh)
    assert_equal exp1, hsh                               
    @builder.doc_new(hsh)
    assert_equal exp2, hsh
  end

  def test_space
    assert_equal 1, @builder.index(2,2) 
    assert_equal 1, @builder.index(8,8) 
    assert_equal 3, @builder.index(9,3) 
    assert_equal 0, @builder.index(4,3)
    assert_equal 0, @builder.index(0,2)
  end
  
  def test_to_adr_all_numbers
    adr = [1, 2, 3]
    exp = "[1][2][3]"
    assert exp, @builder.to_adr(adr)
  end

  ##
  # address object
  #
  def test_adr_obj
    x = "awesome"
    hsh = {1 => [{"k1" => x}]}
    adr = [1, 0, "k1"]
    act = @builder.adr_obj(hsh, adr)
    assert_equal x, act 
  end

  def test_to_adr_all_string
    adr = ["k1", "k2"]
    exp = "['k1']['k2']"
    assert exp, @builder.to_adr(adr)
  end

  def test_to_adr_mixed
    adr = ["k1", 1, 2, 3, "k2", 4]
    exp = "['k1'][1][2][3]['k2'][4]"
    assert exp, @builder.to_adr(adr)
  end

  def test_add_to_list
    lst = {}
    exp_lst1 = {1 => "k1"}
    exp_lst2 = {1 => "k1", 2 => "k1,k2"}
    exp_lst3 = {1 => "k1", 2 => "k1,k2", 3 => "string"}
    @builder.add_to_list(lst, ["k1"])
    assert_equal exp_lst1, lst
    @builder.add_to_list(lst, ["k1","k2"])
    assert_equal exp_lst2, lst
    @builder.add_to_list(lst, "string")
    assert_equal exp_lst3, lst
  end

  def test_update_index_greater_than_before
    # index > length
    idx = 5
    adr = [1,2,3,4,5]
    exp = "gt"
    act = @builder.update(adr, idx)
    assert_equal 5, adr.length
    assert_equal exp, act
  end

  def test_update_index_same_as_before
    # index == length; remain the same
    idx = 4 
    adr = [1,2,3,4,5]
    exp = "eq"
    act = @builder.update(adr, idx)
    assert_equal 5, adr.length
    assert_equal exp, act
  end

  def test_update_index_less_than_before
    # remain the same because 0 is the doc
    idx = 3
    adr = [1,2,3,4,5]
    exp_msg = "lt"
    exp_adr = [1,2,3,4]
    act = @builder.update(adr, idx)
    assert_equal 4, adr.length
    assert_equal exp_msg, act
    assert_equal exp_adr, adr
  end

  def test_update_zero_index
    idx = 0
    adr = [1,2,3,4,5]
    exp_msg = "lt"
    exp_adr = [1]
    act = @builder.update(adr, idx)
    assert_equal 1, adr.length
    assert_equal exp_msg, act
    assert_equal exp_adr, adr
  end

  def test_blank_line
    hsh = {:lst => {}} 
    exp_lst1 = {1=>"#BLANK"}
    exp_lst2 = {1=>"#BLANK",2=>"#BLANK"}
    @builder.blank(hsh[:lst])
    assert_equal exp_lst1, hsh[:lst] 
    @builder.blank(hsh[:lst])
    assert_equal exp_lst2, hsh[:lst] 
  end

  def test_doc_start
    hsh = {} 
    exp_lst1 = {1=>"#DOC_START"}
    exp_lst2 = {1=>"#DOC_START",2=>"#DOC_START"}
    @builder.doc_start(hsh)
    assert_equal exp_lst1, hsh[:lst] 
    @builder.doc_start(hsh)
    assert_equal exp_lst2, hsh[:lst] 
  end

  def test_doc_term
    hsh = {:adr => [], :lst => {}}
    exp_lst1 = {1 => "#DOC_TERM"}
    exp_lst2 = {1 => "#DOC_TERM", 2 => "#DOC_TERM"}
    @builder.doc_term(hsh)
    assert_equal exp_lst1, hsh[:lst]
    @builder.doc_term(hsh)
    assert_equal exp_lst2, hsh[:lst]
  end

  def test_hashkey_into_hash
    las = {}
    adr = []
    @builder.hsh_key(las, adr, "k1")
    exp_las = {"k1" => {}}
    exp_adr = ["k1"]
    assert_equal exp_las, las
    assert_equal exp_adr, adr
  end

  def test_hashkey_into_array
    las = []
    adr = []
    @builder.hsh_key(las, adr, "k1")
    exp_las = [{"k1" => {}}]
    exp_adr = [0,"k1"]
    assert_equal exp_las, las
    assert_equal exp_adr, adr
  end

  def test_hashpair_into_hash
    las  = {} 
    exp1 = {"k1" => "awesome"}
    exp2 = {"k1" => "awesome", "k2" => "dude"}
    @builder.hsh_pair(las, "k1", "awesome")
    assert_equal exp1, las
    @builder.hsh_pair(las, "k2", "dude")
    assert_equal exp2, las
  end
  
  def test_hashpair_into_array
    las  = [] 
    exp1 = [{"k1" => "awesome"}]
    exp2 = [{"k1" => "awesome"}, {"k2" => "dude"}]
    @builder.hsh_pair(las, "k1", "awesome")
    assert_equal exp1, las
    @builder.hsh_pair(las, "k2", "dude")
    assert_equal exp2, las
  end
  
  def test_comment
    lst = {}
    exp = {1 => "#COMMENT: awesome"}
    @builder.comment(lst, "awesome")
    assert_equal exp, lst
    exp = {1 => "#COMMENT: awesome", 2 => "#COMMENT: dude"}
    @builder.comment(lst, "dude")
    assert_equal exp, lst
  end

  def test_array_into_hash
    las = {}
    adr = []
    exp_las = {}
    exp_adr = []
    val = "awesome"
    @builder.array_new(las, adr, val)
    assert_equal exp_las, las 
    assert_equal exp_adr, adr
  end

  def test_array_into_array
    las = [3]
    adr = []
    val = "awesome"
    exp_las = [3,["awesome"]]
    exp_adr = [1]
    @builder.array_new(las, adr, val)
    assert_equal exp_las, las 
    assert_equal exp_adr, adr
  end

  def test_add_value_to_array
    las = []
    adr = []
    @builder.array_val(las, 1)
    assert_equal [], adr
    assert_equal [1], las
    @builder.array_val(las, 2)
    assert_equal [], adr
    assert_equal [1,2], las
  end

  def test_malformed
    lst = {}
    exp = {1 => "#MALFORMED: string1"}
    @builder.malformed(lst, "string1")
    assert_equal exp, lst
    exp = {1 => "#MALFORMED: string1", 2 => "#MALFORMED: string2"}
    @builder.malformed(lst, "string2")
    assert_equal exp, lst
  end
end
