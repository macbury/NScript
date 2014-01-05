module NScript::Backend

  class Base
    SIZE = 1000

    def initialize
      @fibers = []

      SIZE.times do
        @fibers << Fiber.new { |block| loop { block = fiber_loop(block) } }
      end
    end

    def schedule(&block)
      throw "unimplemented!"
    end

    protected
      def in_fiber(&block)
        fail 'Server is at capacity' unless (fiber = @fibers.shift)
        fiber.resume(block)
      end

      def fiber_loop(block)
        block.call
        @fibers.unshift Fiber.current
        Fiber.yield
      end
  end
  
end