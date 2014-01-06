module NScript::Backend

  class Eventmachine < Base
    def schedule(&block)
      EM.next_tick { in_fiber(&block) }
    end
  end
  
end