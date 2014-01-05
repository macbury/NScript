module NScript::Backend

  class Base

    def initialize
      @fibers = []
    end

    def schedule(&block)
      throw "unimplemented!"
    end

    private

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