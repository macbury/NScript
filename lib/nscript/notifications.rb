module NScript
  class Notifications
    def initialize(backend)
      @backend = backend
      @events  = {}
    end

    def events
      @events.keys
    end

    def on(event, context, &block)
      @events[event] ||= {}
      @events[event][context] = block
    end

    def count(event)
      @events[event] ? @events[event].size : 0
    end

    def off(event,context=nil)
      if @events[event]
        if context
          @events[event].delete(context) 
        else
          @events[event].clear
        end
        @events.delete(event) if @events[event].empty?
      end
    end

    def trigger(event, payload={})
      broadcast(false, "triggered.event", { event: event, payload: payload })
      broadcast(true,  event, payload)
    end

    private

      def broadcast(with_backend, event, payload={})
        list = @events[event] || []

        list.each do |context, block| 
          if with_backend
            @backend.schedule { context.instance_exec(payload, &block) }
          else
            context.instance_exec(payload, &block)
          end
        end
      end
  end
end
