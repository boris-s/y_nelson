# -*- coding: utf-8 -*-

require 'minitest/spec'
require 'minitest/autorun'
# tested component itself
require './../lib/y_nelson'

# **************************************************************************
# Nelson net test
# **************************************************************************
#
describe YNelson do
  before do
    skip
    @m = YNelson::Manipulator.new
    @p = @m.Place default_marking: 3.2,
                  marking: 1.1,
                  quantum: 0.1
  end

  describe YNelson::Dimension do
    it "should give same instance for same object" do
      assert_equal YNelson.Dimension( :xxx ), @m.Dimension( :xxx )
    end
  end

  describe "new transition form correct zz connections with places" do
    it "should work as expected" do
      assert_equal [], @p.neighbors
      assert_equal [], @p.connectivity # 'connectivity' now exclusively a zz keyword
      t = @m.Transition codomain: @p, action: lambda { 0.1 }, assignment: true
      assert_equal [ @p ], t.neighbors
      dim = @m.Dimension( :codomain, 0 )
      assert_equal @p, t.along( dim ).posward.neighbor
      # And then, it would be the job of dimension reduction to determine if
      # some dimensions should be visualized or otherwise used together.
    end
  end

  it "should work" do
    # TODO:
    # has point
    # has dimension point
    # can create places
    @m.Place
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

describe YNelson::ZzPoint do
  it "should work" do
    # TODO
  end
end

describe YNelson::DimensionPoint do
  it "should work" do
    # TODO
  end
end

describe "visualization" do
  before do
    @m = YNelson::Manipulator.new
    @m.Place name: :A, m!: 3.2
    @m.Place name: :B, m!: 5
    @m.Transition name: :T1, s: { A: -1, B: 1 }, rate: 1
    @m.Place name: :C, m!: 7.0
    @m.Transition name: :T2, s: { B: -1, C: 1 }, rate: 1
  end

  it "should work" do
    dim1 = YNelson::Dimension( :domain, 0 )
    dim2 = YNelson::Dimension( :codomain, 1 )
    skip "temporary problem with graphviz"
    @m.visualize dim1, dim2
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
