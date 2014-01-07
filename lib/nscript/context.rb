module NScript
  class Context

    def initialize
      @nodes         = {}
      @connections   = {}
      @variables     = VariableStorage.new 
      @backend       = NScript::Backend::Sync.new
      @notifications = Notifications.new(@backend)
      @guid          = 0

      @running       = false
    end

    def backend=(new_backend)
      @backend = new_backend
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

    # Generate unique id
    def guid
      @guid += 1
      @guid
    end

    def running?
      @running
    end

    # Start graph and triggers events "graph.start" and "graph.start_finished"
    def start
      throw "Already running!" if @running
      @running = true
      notifications.trigger("graph.start")
      notifications.trigger("graph.start_finished")
    end

    # Stop graph
    def stop
      throw "Not running!" unless @running
      @running = false
      backend.stop
      notifications.trigger("graph.stop")
    end

    def restart
      stop
      start
    end

    def include?(node)
      !@nodes[node.guid].nil?
    end

    # Add node by template key 
    # @param [String] [template name from NScript.nodes.list]
    # @return [NScript::Node::Node] [added node]
    def add_node(name, options={})
      return push(NScript.nodes.build(self, name))
    end

    # Add node variable
    # @param [Hash] [Hash for NScript::NodeBuilder::VarDef options]
    # @return [NScript::Node::Variable] [added node]
    def add_var(options)
      node = NScript::Node::Variable.new(self)
      node.group = "variable"
      node.name  = "value"
      push(node)
      node.setup_variable(options)
      return node
    end

    # Remove node and disconnect connections and trigger "graph.node.remove"
    # @param [NScipt::Node::Base] [node to remove]
    def remove(node)
      if include?(node)
        @nodes.delete(node.guid)
        node.on_remove
        notifications.trigger("graph.node.remove", { guid: node.guid })
      end
    end

    # Connect nodes using IO pipes and triggers "graph.node.connect" event
    # @param [String] [guid of node]
    # @return [NScript::Node::Base]
    def get(guid)
      @nodes[guid]
    end

    # Are nodes connected
    # @param [NScript::Node::IO] [output pipe]
    # @param [NScript::Node::IO] [input pipe]
    def connected?(output, input)
      @connections[output.guid] && @connections[output.guid].include?(input.guid)
    end

    def valid?(output, input)
      raise "Invalid pipe. Should be output" unless output.out?
      raise "Invalid pipe. Should be input" unless input.in?
      raise "Cannot connect the same node" if input.node == output.node
      true
    end

    # Assign node variable to variable in node
    # @param [NScript::Node::Variable] [variable to connect]
    # @param [NScript::Node::Node] [node with variables] 
    # @param [String] [variable name] 
    def assign(variable_node, node, variable_name)
      node.var.connect(variable_name, variable_node.guid)
    end

    # Unassign node variable to variable in node
    def unassign(node, variable_name)
      node.var.disconnect(variable_name)
    end

    # Connect nodes using IO pipes and triggers "graph.node.connect" event
    # @param [NScript::Node::IO] [output pipe]
    # @param [NScript::Node::IO] [input pipe]
    def connect(output, input)
      valid?(output, input)

      @connections[output.guid] ||= []
      @connections[output.guid] << input.guid unless connected?(output, input)
      notifications.trigger("graph.node.connect", {
        input:  input.guid,
        output: output.guid
      })
    end

    # Disconnect nodes using IO pipes and triggers "graph.node.disconnect" event
    # @param [NScript::Node::IO] [output pipe]
    # @param [NScript::Node::IO] [input pipe]
    def disconnect(output, input)
      valid?(output, input)

      if connected?(output, input)
        @connections[output.guid].delete(input.guid)
        @connections.delete(output.guid) if @connections[output.guid].empty?

        notifications.trigger("graph.node.disconnect", {
          input:  input.guid,
          output: output.guid
        })
      end
    end

    def trigger_output(guid, payload={})
      output = @connections[guid] || []
      output.each do |input|
        notifications.trigger(input, payload)
      end
    end

    private
      
      # Setup and push node to stack and then triggers "graph.node.add"
      # @param [NScript::Node::Base] [node to push]
      # @return [NScript::Node::Base] [added node]
      def push(node)
        @nodes[node.guid] = node
        node.setup
        notifications.trigger("graph.node.add", { guid: node.guid })
        node
      end
  end
end