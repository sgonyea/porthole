$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'porthole'

class Unescaped < Porthole
  self.path = File.dirname(__FILE__)

  def title
    "Bear > Shark"
  end
end

if $0 == __FILE__
  puts Unescaped.to_html
end
