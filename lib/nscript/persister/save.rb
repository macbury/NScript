module NScript::Persister

  class Save
    def initialize(context)
      @context = context
      @meta    = {}
    end

    def meta
      @meta
    end

    def meta=(meta_tags={})
      @meta = meta_tags
    end

    def save(filepath)
      nodes = @context.nodes.inject({}) { | h, (key, value) | h[key]=value.to_h; h }

      output = { 
        version: NScript::VERSION,
        meta: @meta,
        graph: {
          guid:         @context.guid,
          connections:  @context.connections,
          nodes:        nodes
        }
      }

      File.open(filepath, "w") do |f|
        f.puts JSON.pretty_generate(output)
        f.close
      end 
    end
  end
end