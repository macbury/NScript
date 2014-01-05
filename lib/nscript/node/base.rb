module NScript::Node
  class Base
    attr_accessor :name, :group

    def initialize(context)
      @context = context
    end

    def guid
      throw "Node must have name!!!" if name.nil?
      @guid ||= [group, name, context.guid].join(".")
    end

    def context
      @context
    end

    def io
      @io ||= NScript::Node::IOPipeline.new(self)
    end

    def var
      @variable_pipeline ||= VariablePipeline.new(self)
    end

    def setup_lifecycle_blocks(run_block=nil, start_block=nil, stop_block=nil)
      define_singleton_method(:lifecycle_start, start_block) if start_block
      define_singleton_method(:lifecycle_run,   run_block)   if run_block
      define_singleton_method(:lifecycle_stop,  stop_block)  if stop_block
    end

    def start_callback?
      respond_to?(:lifecycle_start)
    end

    def run_callback?
      respond_to?(:lifecycle_run)
    end

    def run(payload)
      lifecycle_run(payload) if run_callback? #TODO Do some exception handling
    end

    def stop_callback?
      respond_to?(:lifecycle_stop)
    end
  end
end