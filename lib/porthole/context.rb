class Porthole
  # A ContextMiss is raised whenever a tag's target can not be found
  # in the current context if `Porthole#raise_on_context_miss?` is
  # set to true.
  #
  # For example, if your View class does not respond to `music` but
  # your template contains a `{{music}}` tag this exception will be raised.
  #
  # By default it is not raised. See Porthole.raise_on_context_miss.
  class ContextMiss < RuntimeError;  end

  # A Context represents the context which a Porthole template is
  # executed within. All Porthole tags reference keys in the Context.
  class Context
    # Expect to be passed an instance of `Porthole`.
    def initialize(porthole)
      @stack = [porthole]
    end

    # A {{>partial}} tag translates into a call to the context's
    # `partial` method, which would be this sucker right here.
    #
    # If the Porthole view handling the rendering (e.g. the view
    # representing your profile page or some other template) responds
    # to `partial`, we call it and render the result.
    def partial(name, indentation = '')
      # Look for the first Porthole in the stack.
      porthole = porthole_in_stack

      # Indent the partial template by the given indentation.
      part = porthole.partial(name).to_s.gsub(/^/, indentation)

      # Call the Porthole's `partial` method and render the result.
      result = porthole.render(part, self)
    end

    # Find the first Porthole in the stack. If we're being rendered
    # inside a Porthole object as a context, we'll use that one.
    def porthole_in_stack
      @stack.detect { |frame| frame.is_a?(Porthole) }
    end

    # Allows customization of how Porthole escapes things.
    #
    # Returns a String.
    def escapeHTML(str)
      porthole_in_stack.escapeHTML(str)
    end

    # Adds a new object to the context's internal stack.
    #
    # Returns the Context.
    def push(new)
      @stack.unshift(new)
      self
    end
    alias_method :update, :push

    # Removes the most recently added object from the context's
    # internal stack.
    #
    # Returns the Context.
    def pop
      @stack.shift
      self
    end

    # Can be used to add a value to the context in a hash-like way.
    #
    # context[:name] = "Chris"
    def []=(name, value)
      push(name => value)
    end

    # Alias for `fetch`.
    def [](name)
      fetch(name, nil)
    end

    # Do we know about a particular key? In other words, will calling
    # `context[key]` give us a result that was set. Basically.
    def has_key?(key)
      !!fetch(key)
    rescue ContextMiss
      false
    end

    # Similar to Hash#fetch, finds a value by `name` in the context's
    # stack. You may specify the default return value by passing a
    # second parameter.
    #
    # If no second parameter is passed (or raise_on_context_miss is
    # set to true), will raise a ContextMiss exception on miss.
    def fetch(name, default = :__raise)
      @stack.each do |frame|
        # Prevent infinite recursion.
        next if frame == self

        value = find(frame, name, :__missing)
        if value != :__missing
          return value
        end
      end

      if default == :__raise || porthole_in_stack.raise_on_context_miss?
        raise ContextMiss.new("Can't find #{name} in #{@stack.inspect}")
      else
        default
      end
    end

    # Finds a key in an object, using whatever method is most
    # appropriate. If the object is a hash, does a simple hash lookup.
    # If it's an object that responds to the key as a method call,
    # invokes that method. You get the idea.
    #
    #     obj - The object to perform the lookup on.
    #     key - The key whose value you want.
    # default - An optional default value, to return if the
    #           key is not found.
    #
    # Returns the value of key in obj if it is found and default otherwise.
    def find(obj, key, default = nil)
      hash = obj.respond_to?(:has_key?)

      if hash && obj.has_key?(key)
        obj[key]
      elsif hash && obj.has_key?(key.to_s)
        obj[key.to_s]
      elsif !hash && obj.respond_to?(key)
        meth = obj.method(key) rescue proc { obj.send(key) }
        if meth.arity == 1
          meth.to_proc
        else
          meth[]
        end
      else
        default
      end
    end
  end
end
