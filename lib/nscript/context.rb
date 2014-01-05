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

    def connections
      @connections
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
      node              = NScript.nodes.build(self, name)
      @nodes[node.guid] = node
      notifications.trigger("graph.node.add", { guid: node.guid })
      return node
    end

    def get(guid)
      @nodes[guid]
    end

    # input has many outputs "output" => ["input"]
    def connect(output, input)
      raise "Invalid pipe. Should be output" unless output.out?
      raise "Invalid pipe. Should be input" unless input.in?
      @connections[output.guid] ||= []
      @connections[output.guid] << input.guid unless @connections[output.guid].include?(input.guid)
      notifications.trigger("graph.node.connect", {
        input:  input.guid,
        output: input.guid
      })
    end

    def trigger_output(guid, payload={})
      output = @connections[guid] || []
      output.each do |input|
        notifications.trigger(input, payload)
      end
    end
  end
end