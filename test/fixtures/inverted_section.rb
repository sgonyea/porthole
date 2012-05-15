$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'porthole'

class InvertedSection < Porthole
  self.path = File.dirname(__FILE__)

  def t
    false
  end

  def two
    "second"
  end
end
