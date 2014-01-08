module NScript::Node
  class Base
    attr_accessor :name, :group, :x, :y, :note

    def initialize(context, options={})
      @context = context
      @x       = 0
      @y       = 0
      @note    = note

      self.note = options[:note] if options.key?(:note)
      self.guid = options[:guid] if options.key?(:guid)
      self.x    = options[:x]    if options.key?(:x)
      self.y    = options[:y]    if options.key?(:y)
    end

    # identify node type string
    def self.key
      "base"
    end

    # fired afer node is added to stack
    def setup
      
    end

    # Generate unique id for node
    def guid
      throw "Node must have name!!!" if name.nil?
      @guid ||= [self.class.key, [group, name, context.guid].compact.join(".")].join(":")
    end

    def guid=(nguid)
      @guid = nguid
    end

    # Execution context
    def context
      @context
    end

    # Fired after node is removed from context
    def on_remove

    end

    def to_h
      { guid: self.guid, name: name, group: group, x: x, y: y, type: self.class.key, note: note }
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