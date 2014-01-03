module NScript::NodeBuilder
  
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

    def build(key)
      builder = get(key)
      throw "Could not find builder name #{key}" if builder.nil?
      builder.build
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