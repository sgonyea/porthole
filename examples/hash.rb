$LOAD_PATH.unshift File.dirname(__FILE__) + '/../lib'
require 'porthole'

Porthole.template_file = File.dirname(__FILE__) + '/simple.porthole'
view = Porthole.new

print "Your name: "
view[:name] = gets
view[:value] = value = rand(10_000)
print "Are you in CA? [y/n] "

if view[:in_ca] = gets.to_s.downcase[0].chr == 'y'
  view[:taxed_value] = value - (value * 0.4)
end

puts view.render
