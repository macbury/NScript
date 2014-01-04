module NScript::Var
  class String < Base
    def set(value)
      @value = value.to_s
    end

    def get
      @value
    end
  end
end