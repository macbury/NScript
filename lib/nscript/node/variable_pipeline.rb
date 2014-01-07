module NScript::Node
  class VariablePipeline
    def initialize(node)
      @node     = node
      @base_key = node.guid

      @registered_variables = []
      @connected_variables  = {}
      throw "Base key cannot be nil!!!" unless @base_key 
    end

    def unregister
      @registered_variables.each { |key| @node.context.variables.remove(key) }
    end

    def register_var(var_def)
      default_key = [@base_key, "var", var_def.name].join(".")
      @registered_variables << default_key
      @node.context.variables.setup(default_key, var_def.to_var)

      key_method = "#{var_def.name}_key"

      define_singleton_method "#{key_method}=" do |key|
        @connected_variables[key_method] = key
        key
      end

      define_singleton_method key_method do
        return @connected_variables[key_method] || default_key
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