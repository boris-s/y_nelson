# -*- coding: utf-8 -*-
#! /usr/bin/ruby
#coding: utf-8

require 'minitest/spec'
require 'minitest/autorun'
# tested component itself
require './../lib/y_ted/nelson'

# **************************************************************************
# Nelson net test
# **************************************************************************
#
describe YTed::Nelson do
  before do
    @m = YTed::Nelson::Manipulator.new
  end

  it "should work" do
    # TODO:
    # has point
    # has dimension point
    # can create places
    # can remove places
  end

  describe "small Nelson net" do
    before do
      # TODO:
      # Create a net of several places and transition
    end

    it "should work" do
      # TODO:
      # exercise the created Nelson net to make sure it works
      # #set_posward_neighbor
      # #set_negward_neighbor
      # #along, #posward, #negward, etc...
    end
  end
end

describe YTed::Point do
  it "should work" do
    # TODO
  end
end

describe YTed::DimensionPoint do
  it "should work" do
    # TODO
  end
end

# describe "zz structure with a transition or two" do
#   before do
#     new_zz_sheet "koko"
#     @c1, @c2, @c3 = ZzCell( 1 ), ZzCell( 2 ), ZzCell( 3 )
#     new_zz_row @c1, @c2, @c3
#     @c4 = ϝ { |a0, b0, c0| a0 + b0 + c0 }
#     new_zz_row @c4
#   end

#   it "should have #make_transitions" do
#     tt = make_transitions
#     assert_equal 1, tt.size
#     t = tt[0]
#     assert_kind_of ::YPetri::Transition, t
#     assert t.domain.include? @c1
#     assert t.domain.include? @c2
#     assert t.domain.include? @c3
#     assert_equal nil, @c4.marking
#     t.fire!
#     assert_equal 6, @c4.marking
#     new_zz_sheet "pipi"
#     @c5 = ϝ { |koko_a0, koko_b0| koko_a0 + koko_b0 }
#     tt = make_transitions
#     tt.each &:fire!
#     assert_equal 3, @c5.value
#   end
# end