module NScript::NodeBuilder
  class Base
    def initialize(group, name)
      @group     = group
      @name      = name
      @inputs    = []
      @outputs   = []
      @variables = []
    end

    def key
      [@group, @name].join(".")
    end

    def input(name=:input)
      @inputs    << IODef.new(name)
    end

    def output(name=:output)
      @outputs   << IODef.new(name)
    end

    def var(name, options={})
      @variables << VarDef.new(name, options)
    end

    def run(&block)
      @run_block = block
    end

    def start(&block)
      @start_block = block
    end

    def stop(&block)
      @stop_block = block
    end

    def build(context, options={})
      node       = NScript::Node::Node.new(context, options)
      node.name  = @name
      node.group = @group
      node.setup_lifecycle_blocks(@run_block, @start_block, @stop_block)
      
      @variables.each do |var|
        node.var.register_var(var)
      end

      @inputs.each do |input|
        node.io.register_input(input)
      end

      @outputs.each do |output|
        node.io.register_output(output)
      end

      return node
    end

    def inspect
      "<#{self.class} 0x#{self.object_id} name=#{@name.inspect} group=#{@group.inspect} outputs=#{@outputs.count.inspect} inputs=#{@inputs.count.inspect}>"
    end

    def to_s
      inspect
    end
  end
end