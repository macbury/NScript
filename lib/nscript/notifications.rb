module NScript
  class Notifications
    def initialize(backend)
      @backend = backend
      @events  = {}
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
        @events[event].delete(context) if context
        @events.delete(event) if @events[event].empty?
      end
    end

    def trigger(event, payload={})
      list = @events[event] || []

      list.each do |context,block| 
        @backend.schedule { context.instance_exec(payload, &block) }
      end
    end
  end
end
