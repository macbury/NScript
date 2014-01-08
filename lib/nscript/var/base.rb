module NScript::Var
  class Base
    def initialize(default_value)
      @default = default_value
      reset
    end

    def set(value)
      throw "You must implement set for #{self.class}"
    end

    def get
      throw "You must implement get for #{self.class}"
    end

    def reset
      set(@default)
    end

    def default
      @default
    end

    def default=(default_value)
      set(default_value)
      @default = get
    end

    def type
      self.class
    end
  end
end