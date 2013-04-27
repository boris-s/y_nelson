# Let's see whether just subclassing YPetri::Transition will do...
# 
class YTed::Nelson::Transition < YPetri::Transition
  include YTed::Zz

  private

  # Place, Transition, Net class
  # 
  def Place; ::YTed::Nelson::Place end
  def Transition; ::YTed::Nelson::Transition end
  def Net; ::YTed::Nelson::Net end
end
