# Represents Petri nets inside the Nelson net.
# 
class YTed::Nelson::PetriNet < YPetri::Net

  private

  # Place, Transition, Net class
  # 
  def Place; ::YTed::Nelson::Place end
  def Transition; ::YTed::Nelson::Transition end
  def Net; ::YTed::Nelson::PetriNet end
end
