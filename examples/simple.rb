$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'porthole'

class Simple < Porthole
  self.path = File.dirname(__FILE__)

  def name
    "Chris"
  end

  def value
    10_000
  end

  def taxed_value
    value - (value * 0.4)
  end

  def in_ca
    true
  end
end

puts Simple.render if $0 == __FILE__
