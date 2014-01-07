module NScript::Node
  class Variable < Base
    attr_accessor :description

    def setup
      setup_variable(type: Integer, default: 0)
    end

    # Setup variable
    # @param [Hash] [NScript::NodeBuilder::VarDef options]
    def setup_variable(options)
      @var = NScript::NodeBuilder::VarDef.new(:value, options).to_var
      context.variables.setup(self.guid, @var)
    end

    def read
      context.variables.read(self.guid)
    end

    def write(value)
      context.variables.write(self.guid, value)
    end

    def variable
      @var
    end

    def on_remove
      context.notifications.trigger([self.guid, "remove"].join("."))
      context.backend.future { context.variables.remove(self.guid) }
    end

    def key
      "global"
    end

    def to_h
      super.merge({ value: @var.default })
    end
  end
end