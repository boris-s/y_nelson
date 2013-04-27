# Represents Petri nets inside the Nelson net.
# 
class YNelson::Net < YPetri::Net

  private

  # Place, Transition, Net class
  # 
  def Place; ::YNelson::Place end
  def Transition; ::YNelson::Transition end
  def Net; ::YNelson::Net end
end # class YNelson::Net
