module NScript::Var
  class Float < Base
    def set(value)
      @value = value.to_f
    end

    def get
      @value
    end
  end
end