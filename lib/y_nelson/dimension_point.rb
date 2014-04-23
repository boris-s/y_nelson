#encoding: utf-8

# A pointer to a zz dimension.
# 
class YNelson::DimensionPoint
  attr_accessor :dimension

  def initialize dimension
    @dimension = dimension
  end

  def default_dimension
    YNelson.default_dimension
  end
end # class YTed::DimensionPoint
