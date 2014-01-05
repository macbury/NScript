module NScript
  class Context

    def initialize
      @nodes         = {}
      @connections   = {}
      @variables     = VariableStorage.new 
      @backend       = NScript::Backend::Sync.new
      @notifications = Notifications.new(@backend)
      @guid          = 0
    end

    def backend
      @backend
    end

    def variables
      @variables 
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
      node = NScript.nodes.build(self, name)
      @nodes[node.guid] = node
      notifications.trigger("graph.node.add", { guid: node.guid })
      return node
    end

    def connect(input, output)
      notifications.trigger("graph.node.connect")
    end

    private

      def run_in_fiber
        
      end
  end
end