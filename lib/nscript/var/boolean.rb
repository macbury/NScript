module NScript::Var
  class Boolean < Base
    def set(value)
      @value = !!value
    end

    def get
      @value
    end
  end
end