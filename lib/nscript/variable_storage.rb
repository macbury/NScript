module NScript
  class VarNotFound < Exception
    def initialize(name)
      super("Variavle not found: #{name.inspect}")
    end
  end

  class VariableStorage
    def initialize
      @vars = {}
    end
    
    def keys
      @vars.keys
    end

    def setup(key, var)
      @vars[key] = var
    end

    def write(key, value)
      if @vars[key]
        @vars[key].set(value) 
      else
        raise VarNotFound.new(key)
      end
    end

    def type_of(key)
      if @vars[key]
        @vars[key].type 
      else
        raise VarNotFound.new(key)
      end
    end

    def read(key)
      if @vars[key] 
        @vars[key].get
      else
        raise VarNotFound.new(key)
      end
    end
  end
end