module NScript::Node
  class VariablePipeline

    def initialize
      @variables = {}
    end

    def add(var_def)
      define_singleton_method var_def.name do

      end
    end

  end
end