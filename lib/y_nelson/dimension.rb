# -*- coding: utf-8 -*-
# Zz dimension can in principle be any object, in YNelson, special class
# Dimension is used.
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
    # same constructor arguments.
    # 
    def new *args
      instances.find { |ɪ| ɪ.object == args } or
        __new__( *args ).tap { |ɪ| instances << ɪ }
    end
  end

  attr_reader :object

  # Simply assigns array of arguments to @object atrribute.
  # 
  def initialize *args
    @object = args
  end

  # Short instance description string.
  # 
  def to_s
    "#<YNelson::Dimension [#{object.join ', '}]>"
  end
end # class YNelson::Dimension

# Convenience constructor.
# 
def YNelson.Dimension *args
  YNelson::Dimension.new *args
end
