module NScript::Node
  class VariablePipeline
    def initialize(context, base_key)
      @context  = context
      @base_key = base_key
      throw "Base key cannot be nil!!!" unless @base_key 
    end

    def register_var(var_def)
      key = [@base_key, var_def.name].join(".")
      @context.variables.setup(key, var_def.to_var)

      key_method = "#{var_def.name}_key"

      define_singleton_method key_method do
        return key
      end

      define_singleton_method var_def.name do
        @context.variables.read(send(key_method))
      end

      define_singleton_method "#{var_def.name.to_sym}=" do |val|
        @context.variables.write(send(key_method), val)
      end
    end
  end
end