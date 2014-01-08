module NScript::Node
  class Node < Base
    include NScript::Node::Helpers::Time
    include NScript::Node::Helpers::Http

    # Fired after node have been build and added to context
    def setup
      @running_count = 0
      @context.notifications.on("graph.start", self) { start }
      @context.notifications.on("graph.stop", self)  { stop }

      start if @context.running?
    end

    def running?
      @running_count > 0
    end

    def running_count
      @running_count
    end

    def self.key
      "!logic"
    end

    # Returns all ios for this node
    # @return [NScript::Node::IOPipeline] [inputs and outputs]
    def io
      @io ||= NScript::Node::IOPipeline.new(self)
    end

    # Returns all variables for this node
    # @return [NScript::Node::VariablePipeline] [variables]
    def var
      @variable_pipeline ||= VariablePipeline.new(self)
    end

    def setup_lifecycle_blocks(run_block=nil, start_block=nil, stop_block=nil)
      define_singleton_method(:lifecycle_start, start_block) if start_block
      define_singleton_method(:lifecycle_run,   run_block)   if run_block
      define_singleton_method(:lifecycle_stop,  stop_block)  if stop_block
    end

    # Fired after node is removed from context
    def on_remove
      @context.notifications.off("graph.start", self)
      @context.notifications.off("graph.stop", self)

      io.outputs.each { |k, o| @context.connections.delete(o.guid) }
      io.unregister_inputs
      var.unregister
      stop
    end

    def start_callback?
      respond_to?(:lifecycle_start)
    end

    def run_callback?
      respond_to?(:lifecycle_run)
    end

    # Start node and triggers "graph.node.before_start"
    def start
      is_running do
        context.notifications.trigger("graph.node.before_start", { guid: self.guid })
        secure_run do
          lifecycle_start if start_callback?
        end
        context.notifications.trigger("graph.node.after_start", { guid: self.guid })
      end
    end

    def run(payload={})
      is_running do
        context.notifications.trigger("graph.node.before_run", { guid: self.guid })
        secure_run do
          lifecycle_run(payload) if run_callback?
        end
        context.notifications.trigger("graph.node.after_run", { guid: self.guid })
      end
    end

    def stop
      is_running do
        context.notifications.trigger("graph.node.before_stop", { guid: self.guid })
        secure_run do
          lifecycle_stop if stop_callback?
        end
        context.notifications.trigger("graph.node.after_stop", { guid: self.guid })
      end
    end

    def stop_callback?
      respond_to?(:lifecycle_stop)
    end

    # for usage in start trigger. Run main node code in next tick or thread(depends on backend). This ensures all start callbacks are triggered
    def execute!
      @context.backend.schedule { run }
    end

    def to_h
      super.merge({ assigns: var.connected_variables })
    end

    private

      def is_running(&block)
        @running_count += 1
        block.call
        @running_count -= 1
      end
  end
end