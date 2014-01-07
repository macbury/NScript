require "em-http-request"

module NScript::Backend

  class Eventmachine < Base

    def initialize
      super
      @resources = {}
    end

    def stop
      @resources.each { |resource, callback| callback.call }
      @resources.clear
    end

    # Reserve resource with callback and yield fiber. After yield clear resource
    # @param [Object] [resource object]
    # @param [Proc] [Run on context stop, add callback for cleaning resource]
    def resource(resource, on_force_finish_callback)
      @resources[resource] = on_force_finish_callback
      Fiber.yield
      @resources.delete(resource)
    end

    # Run block in fiber and next reactor tick
    # @param [Proc] [Block to run in next tick]
    def schedule(&block)
      fiber = pool_fiber
      EM.next_tick { fiber.resume(block) }
    end

    # Run block in next reactor tick
    # @param [Proc] [block to run]
    def future(&block)
      EM.next_tick { block.call }
    end

    def http_get(url, options={})
      f    = Fiber.current
      http = EventMachine::HttpRequest.new(url, options).get

      http.callback { f.resume(http) }
      http.errback  { f.resume(http) }

      resource(http, -> { http.unbind })
      http
    end

    def delay(time)
      fiber = Fiber.current
      timer = EM.add_timer(time) { fiber.resume }
      resource(timer, -> { EM.cancel_timer(timer) })
    end
  end
  
end