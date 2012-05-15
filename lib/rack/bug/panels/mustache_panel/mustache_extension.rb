if defined? Porthole
  require 'benchmark'

  Porthole.class_eval do
    alias_method :real_render, :render

    def render(*args, &block)
      out = ''
      Rack::Bug::PortholePanel.times[self.class.name] = Benchmark.realtime do
        out = real_render(*args, &block)
      end
      out
    end

    alias_method :to_html, :render
    alias_method :to_text, :render
  end

  Porthole::Context.class_eval do
    alias_method :real_get, :[]

    def [](name)
      return real_get(name) if name == :yield || !@porthole.respond_to?(name)
      Rack::Bug::PortholePanel.variables[name] = real_get(name)
    end
  end
end
