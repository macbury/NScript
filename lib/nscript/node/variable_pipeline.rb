module NScript::Node
  class VariablePipeline
    def initialize(context, base_key)
      @context  = context
      @base_key = base_key
    end

    def register_var(var_def)
      key = [@base_key, var_def.name].join(".")
      @context.variables.setup(key, var_def.to_var)

      define_singleton_method var_def.name do
        @context.variables.read(key)
      end

      define_singleton_method "#{var_def.name.to_sym}=" do |val|
        @context.variables.write(key, val)
      end
    end
  end
end