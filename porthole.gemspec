$LOAD_PATH.unshift 'lib'
require 'porthole/version'

Gem::Specification.new do |s|
  s.name              = "porthole"
  s.version           = Porthole::Version
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           =
        "Porthole is a framework-agnostic way to render logic-free views."
  s.homepage          = "http://github.com/sgonyea/porthole"
  s.email             = "me@sgonyea.com"
  s.authors           = [ "Scott Gonyea" ]
  s.files             = %w( README.md Rakefile LICENSE )
  s.files            += Dir.glob("lib/**/*")
  s.files            += Dir.glob("bin/**/*")
  s.files            += Dir.glob("man/**/*")
  s.files            += Dir.glob("test/**/*")
  s.executables       = %w( porthole )
  s.description       = <<desc
Porthole is a ripoff of Mustache. It replaces the use of {{ }} with %% %%, because god hates me.

I removed the Mustache authors from the list of authors, as I don't want to associate their names
with this project. You can find the *real* list of authors by viewing the Ruby Gem "mustache" or
by going to: http://github.com/defunkt/mustache
desc
end
