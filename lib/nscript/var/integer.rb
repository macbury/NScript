module NScript::Var
  class Integer < Base
    def set(value)
      @value = value.to_i
    end

    def get
      @value
    end
  end
end