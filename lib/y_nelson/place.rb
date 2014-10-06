# YNelson::Place is analogical to a spreadsheet cell. It is based on
# YPetri::Place, which is made into a ZZ object using Yzz mixin.
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

  # Subclass of Yzz::PoswardSide.
  # 
  class PoswardSide < Yzz::PoswardSide
    # "Budding": creation of new cells from the cell sides.
    # 
    def bud( value: L!, f: nil )
      # FIXME -- budding from posward side
    end
    alias :>> :bud
  end

  # Subclass of Yzz::NegwardSide.
  # 
  class NegwardSide < Yzz::NegwardSide
    # "Budding": creation of new cells from the cell sides.
    # 
    def bud( value: L!, f: nil )
      # FIXME -- budding from negward side
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
