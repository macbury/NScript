module NScript::NodeBuilder
  class NodeNotFound < Exception
    def initialize(name)
      super("Node template not found with name: #{name.inspect}")
    end
  end

  class Manager
    def initialize
      @list = {}
    end

    def add(builder)
      @list[builder.key] = builder
    end

    def get(key)
      @list[key]
    end

    def build(context, key)
      builder = get(key)
      raise NodeNotFound.new(key) if builder.nil?
      builder.build(context)
    end

    def list
      @list.keys
    end

    def all
      @list.values
    end

    def size
      @list.size
    end

    def clear!
      @list = {}
    end
  end

end