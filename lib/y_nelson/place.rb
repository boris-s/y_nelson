# YNelson::Place is analogical to a spreadsheet cell. It is based on
# YPetri::Place and offers simlar interace.
# 
class YNelson::Place < YPetri::Place
  include YNelson::Yzz
  alias call along # .( :dim ) instead of .along( :dim )

  class << self
  end

  # Subclass of YTed::Zz::Side.
  # 
  class Side < Side
    # "Budding": creation of new cells from the cell sides
    def bud( value: L!, f: nil )
      # FIXME
    end
    alias :>> :bud
  end

  private

  # Place, Transition, Net class
  # 
  def Place; ::YNelson::Place end
  def Transition; ::YNelson::Transition end
  def Net; ::YNelson::Net end
end
