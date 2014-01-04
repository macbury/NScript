module NScript
  class Context

    def initialize
      @nodes         = {}
      @variables     = VariableStorage.new 
      @notifications = Notifications.new
      @guid          = 0
    end

    def notifications
      @notifications
    end

    def guid
      @guid += 1
      @guid
    end

    def start
      notifications.trigger("graph.start")
    end

    def stop
      notifications.trigger("graph.stop")
    end

    def restart
      notifications.trigger("graph.restart")
    end

    def add(name, options={})
      notifications.trigger("graph.node.add")
    end

    def connect(input, output)
      notifications.trigger("graph.node.connect")
    end

    private

      def run_in_fiber
        
      end
  end
end