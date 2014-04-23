# Represents Petri nets inside the Nelson net.
# 
module YNelson::Yzz
  include Yzz

  def along *args
    return super( args[0] ) if
      args.size == 1 && args[0].is_a?( ::YNelson::Dimension )
    super( ::YNelson.Dimension *args )
  end
end # module Yzz
