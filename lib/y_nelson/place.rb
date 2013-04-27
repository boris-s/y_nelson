# Let's see whether just subclassing YPetri::Place will do the job, or module
# shuffling will be required...
# 
class YNelson::Place < YPetri::Place
  include YTed::Zz

  class << self
  end

  # Subclass of Side provided by YTed::Zz - I wonder whether this is a good
  # approach.
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
