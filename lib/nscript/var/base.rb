module NScript::Var
  class Base
    def initialize(default)
      @default = default
      set(@default)
    end

    def set(value)
      throw "You must implement set for #{self.class}"
    end

    def get
      throw "You must implement get for #{self.class}"
    end

    def type
      self.class
    end
  end
end