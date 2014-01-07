module NScript::Node
  class VariablePipeline
    def initialize(node)
      @node     = node
      @base_key = node.guid

      @registered_variables = []
      @connected_variables  = {}
      throw "Base key cannot be nil!!!" unless @base_key 
    end

    def connected_variables
      @connected_variables
    end

    # Connect variable to variable in storage. Binds to target.remove event
    # @param [String] [name of variable defined by var]
    # @param [String] [target guid in variable storage]
    def connect(name, target)
      @connected_variables[name] = target
      @node.context.notifications.on([target, "remove"].join("."), self) { disconnect(name) }
    end

    def connected?(name)
      !@connected_variables[name].nil?
    end

    # Disconnect variable by its name and remove target.remove event
    # @param [String] [name variable]
    def disconnect(name)
      if connected?(name)
        @node.context.notifications.off([@connected_variables[name], "remove"], self)
      end
      @connected_variables.delete(name)
    end

    def unregister
      @connected_variables.values { |key| @node.context.variables.remove(key) }
      @registered_variables.each  { |key| @node.context.variables.remove(key) }
    end

    def register_var(var_def)
      default_key = [@base_key, "var", var_def.name].join(".")
      @registered_variables << default_key
      @node.context.variables.setup(default_key, var_def.to_var)

      key_method = "#{var_def.name}_key"

      define_singleton_method "#{key_method}=" do |key|
        @connected_variables[var_def.name] = key
        key
      end

      define_singleton_method key_method do
        return @connected_variables[var_def.name] || default_key
      end

      define_singleton_method var_def.name do
        @node.context.variables.read(send(key_method))
      end

      define_singleton_method "#{var_def.name.to_sym}=" do |val|
        @node.context.variables.write(send(key_method), val)
      end
    end
  end
end