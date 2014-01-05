module NScript::Node
  class PipeNotFound < Exception
    def initialize(name)
      super("Could not find pipe with #{name.inspect}")
    end
  end

  class IOPipeline
    def initialize(node)
      @node    = node
      @inputs  = {}
      @outputs = {}
    end 

    def get_input(key)
      raise PipeNotFound.new(key) unless @inputs[key]
      @inputs[key]
    end

    def get_output(key)
      raise PipeNotFound.new(key) unless @outputs[key]
      @outputs[key]
    end

    def inputs
      @inputs.keys
    end

    def outputs
      @outputs.keys
    end

    def register_input(io_def)
      @inputs[io_def.name] = IO.new(@node, io_def.name, false)
      @node.context.notifications.on(@inputs[io_def.name].guid, self) { |payload| @node.run(payload) }
    end

    def register_output(io_def)
      @outputs[io_def.name] = IO.new(@node, io_def.name, true)
    end

    def write(name, payload={})
      raise PipeNotFound.new(name) unless @outputs[name]
      @node.context.trigger_output(@outputs[name].guid, payload)
      #@node.context.notifications.trigger(@outputs[name].guid, payload)
    end
  end
end