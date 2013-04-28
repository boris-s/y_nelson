# Let's see whether just subclassing YPetri::Transition will do...
# 
class YNelson::Transition < YPetri::Transition
  include Yzz

  private

  # Place, Transition, Net class
  # 
  def Place; ::YNelson::Place end
  def Transition; ::YNelson::Transition end
  def Net; ::YNelson::Net end
end
