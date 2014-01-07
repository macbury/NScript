module NScript::Node
  class Base
    attr_accessor :name, :group, :x, :y

    def initialize(context)
      @context = context
      @x       = 0
      @y       = 0
    end

    # identify node type string
    def key
      "base"
    end

    # fired afer node is added to stack
    def setup
      
    end

    # Generate unique id for node
    def guid
      throw "Node must have name!!!" if name.nil?
      @guid ||= [group, name, key, context.guid].join(".")
    end

    # Execution context
    def context
      @context
    end

    # Fired after node is removed from context
    def on_remove

    end

    def to_h
      { name: name, group: group, x: x, y: y, type: key }
    end

    private

      # run block if there is any error catch error and trigger notification "graph.error"
      # @param [Proc] [block to run]
      def secure_run(&block)
        begin
          block.call
        rescue Exception => e
          @context.notifications.trigger("graph.error", { guid: self.guid, error: e })
        end
      end
  end
end