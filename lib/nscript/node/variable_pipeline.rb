module NScript::Node
  class VariablePipeline
    def register_var(var_def)
      define_singleton_method var_def.name do
        var_def.default
      end

      define_singleton_method "#{var_def.name.to_sym}=" do |val|
        
      end
    end
  end
end