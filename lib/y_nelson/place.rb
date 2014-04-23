# YNelson::Place is analogical to a spreadsheet cell. It is based on
# YPetri::Place and offers simlar interace.
# 
class YNelson::Place < YPetri::Place
  include YNelson::Yzz

  # include Mongoid::Document
  # store_in collection: "places", database: "y_nelson"

  alias call along # .( :dim ) instead of .along( :dim )

  class << self
    private :new
  end

  def initialize( *args )
    super
    
  end

  # Subclass of YTed::Zz::Side.
  # 
  class Side < Side
    # "Budding": creation of new cells from the cell sides.
    # 
    def bud( value: L!, f: nil )
      # FIXME
    end
    alias :>> :bud
  end

  # Produces the inspect string of the place.
  # 
  def inspect
    # Calling the ancestor's #inspect.
    YPetri::Place.instance_method( :inspect ).bind( self ).call
  end

  # Returns a string briefly describing the place.
  # 
  def to_s
    # Calling the ancestor's #to_s
    YPetri::Place.instance_method( :to_s ).bind( self ).call
  end
end
