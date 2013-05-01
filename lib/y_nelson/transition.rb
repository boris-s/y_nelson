# Let's see whether just subclassing YPetri::Transition will do...
# 
class YNelson::Transition < YPetri::Transition
  include Yzz

  alias call along # .( :dimension ) instead of .along( :dimension )

  private

  # Place, Transition, Net class
  # 
  def Place; ::YNelson::Place end
  def Transition; ::YNelson::Transition end
  def Net; ::YNelson::Net end
end
