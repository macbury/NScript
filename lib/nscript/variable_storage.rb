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

    # Setup default values
    def reset
      @vars.each { |key, var| var.reset }
    end

    # Setup variable for storage
    # @param [String] [Store NScript::Var::Base key]
    # @param [Store NScript::Var::Base] [variable definition]
    def setup(key, var)
      @vars[key] = var
    end

    def remove(key)
      @vars.delete(key)
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

    def to_h
      @vars.inject({}) { | h, (key, var) | h[key]=var.default; h }
    end

    def from_h(hash)
      hash.each do |key, default|
        @vars[key].default = default unless @vars[key].nil?
      end
    end
  end
end