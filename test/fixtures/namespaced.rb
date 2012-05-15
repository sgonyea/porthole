$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'porthole'

module TestViews
  class Namespaced < Porthole
    self.path = File.dirname(__FILE__)

    def title
      "Dragon < Tiger"
    end
  end

  class NamespacedWithPartial < Porthole
    self.path = File.dirname(__FILE__)
    self.template = "My opinion: %%>inner_partial%%"

    def title
      "Victory"
    end
  end
end

if $0 == __FILE__
  puts TestViews::Namespaced.to_html
end
