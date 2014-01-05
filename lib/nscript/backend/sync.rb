module NScript::Backend

  class Sync < Base
    def schedule(&block)
      in_fiber(&block)
    end
  end
  
end