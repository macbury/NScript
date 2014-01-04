module NScript
  class Notifications
    def initialize
      @events = {}
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

    def trigger(event)
      list = @events[event] || []

      list.each do |context,block| 
        context.instance_eval(&block)
      end
    end
  end
end
