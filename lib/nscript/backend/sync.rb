module NScript::Backend

  # for simple testing
  class Sync < Base
    def schedule(&block)
      in_fiber(&block)
    end

    def future(&block)
      block.call
    end

    def delay(time)
      sleep time
    end

    def stop
      
    end
  end
  
end