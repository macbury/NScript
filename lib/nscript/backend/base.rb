module NScript::Backend

  class Base

    def initialize
      @fibers = []
    end

    def fiber_count
      @fibers.size
    end

    def http_get(url, options={})
      throw "unimplemented"
    end

    def stop
      throw "unimplemented"
    end

    def every(time)
      throw "unimplemented"
    end

    def delay(time)
      throw "unimplemented"
    end

    def future(&block)
      throw "unimplemented"
    end

    def schedule(&block)
      throw "unimplemented!"
    end

    def pool_fiber
      @fibers << Fiber.new { |block| loop { block = fiber_loop(block) } } if @fibers.empty?
      @fibers.shift
    end

    protected
      def in_fiber(&block)
        pool_fiber.resume(block)
      end

      def fiber_loop(block)
        block.call
        @fibers.unshift Fiber.current
        Fiber.yield
      end
  end
  
end