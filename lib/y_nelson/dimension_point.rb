#encoding: utf-8

# A pointer to a zz dimension.
# 
class YTed::DimensionPoint
  attr_accessor :dimension

  def initialize( dimension: default_dimension )
    @dimension = dimension
  end

  def default_dimension
    YTed::Nelson.default_dimension
  end
end # class YTed::DimensionPoint
