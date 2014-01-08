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

    def to_h
      variables = []
      logic     = []

      @context.nodes.each do |guid, node|
        if node.class == NScript::Node::Node
          logic << node.to_h
        else
          variables << node.to_h
        end
      end

      output = { 
        version: NScript::VERSION,
        meta: @meta,
        document: {
          guid:         @context.guid,
          connections:  @context.connections,
          logic:        logic,
          variables:    variables,
          values:       @context.variables.to_h
        }
      }

      return output
    end

    def to_json
      JSON.pretty_generate(to_h)
    end

    def save(filepath)
      File.open(filepath, "w") do |f|
        f.puts to_json
        f.close
      end 
    end
  end
end