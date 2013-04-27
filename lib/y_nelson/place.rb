# Let's see whether just subclassing YPetri::Place will do the job, or module
# shuffling will be required...
# 
class YTed::Nelson::Place < YPetri::Place
  include YTed::Zz

  class << self
  end

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
  def Place; ::YTed::Nelson::Place end
  def Transition; ::YTed::Nelson::Transition end
  def Net; ::YTed::Nelson::Net end
end
