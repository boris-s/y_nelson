# -*- coding: utf-8 -*-
# Represents Petri nets inside the Nelson net.
# 
class YNelson::Dimension
  class << self
    alias __new__ new

    # Presents class-owned instances (array).
    # 
    def instances
      return @instances ||= []
    end

    # The #new constructor is changed, so that same instance is returned for
    # equal arguments.
    # 
    def new *args
      instances.find { |ɪ| ɪ.object == args } or
        __new__( *args ).tap { |ɪ| instances << ɪ }
    end
  end

  attr_reader :object

  # 
  def initialize *args
    @object = args
  end

  # Produces 
  # 
  def to_s
    "#<YNelson::Dimension [#{object.join ', '}]>"
  end
end # class YNelson::Net

# Convenience constructor.
# 
def YNelson.Dimension *args; YNelson::Dimension.new *args end
