require 'porthole'
require 'tmpdir'
require 'yaml'
require 'test/unit'

# Automatically process !code types into Proc objects
YAML::add_builtin_type('code') { |_, val| eval(val['ruby']) }

# A simple base class for Porthole specs.
# Creates a partials directory, then points a (dynamic) subclass of Porthole at
# that directory before each test; the partials directory is destroyed after
# each test is run.
class PortholeSpec < Test::Unit::TestCase
  def setup
    @partials = File.join(File.dirname(__FILE__), 'partials')
    Dir.mkdir(@partials)

    @Porthole = Class.new(Porthole)
    @Porthole.template_path = @partials
  end

  def teardown
    Dir[File.join(@partials, '*')].each { |file| File.delete(file) }
    Dir.rmdir(@partials)
  end

  # Extracts the partials from the test, and dumps them into the partials
  # directory for inclusion.
  def setup_partials(test)
    (test['partials'] || {}).each do |name, content|
      File.open(File.join(@partials, "#{name}.porthole"), 'w') do |f|
        f.print(content)
      end
    end
  end

  # Asserts equality between the rendered template and the expected value,
  # printing additional context data on failure.
  def assert_porthole_spec(test)
    actual = @Porthole.render(test['template'], test['data'])

    assert_equal test['expected'], actual, "" <<
      "#{ test['desc'] }\n" <<
      "Data: #{ test['data'].inspect }\n" <<
      "Template: #{ test['template'].inspect }\n" <<
      "Partials: #{ (test['partials'] || {}).inspect }\n"
  end

  def test_noop; assert(true); end
end

spec_files = File.join(File.dirname(__FILE__), '..', 'ext', 'spec', 'specs', '*.yml')
Dir[spec_files].each do |file|
  spec = YAML.load_file(file)

  klass_name = "Test" + File.basename(file, ".yml").sub(/~/, '').capitalize
  instance_eval "class ::#{klass_name} < PortholeSpec; end"
  test_suite = Kernel.const_get(klass_name)

  test_suite.class_eval do
    spec['tests'].each do |test|
      define_method :"test - #{test['name']}" do
        setup_partials(test)
        assert_porthole_spec(test)
      end
    end
  end
end
