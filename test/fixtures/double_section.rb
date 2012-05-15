$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'porthole'

class DoubleSection < Porthole
  self.path = File.dirname(__FILE__)

  def t
    true
  end

  def two
    "second"
  end
end
