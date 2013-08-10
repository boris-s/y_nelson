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
end
