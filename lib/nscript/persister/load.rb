require "mash"
module NScript::Persister
  class Load
    def initialize
      @meta = {}
    end

    def meta
      @meta
    end

    def symbolize_keys(obj)
      case obj
      when Array
        obj.inject([]){|res, val|
          res << case val
          when Hash, Array
            val #symbolize_keys(val)
          else
            val
          end
          res
        }
      when Hash
        obj.inject({}){|res, (key, val)|
          nkey = case key
          when String
            key.to_sym
          else
            key
          end
          nval = case val
          when Hash, Array
            val #symbolize_keys(val)
          else
            val
          end
          res[nkey] = nval
          res
        }
      else
        obj
      end
    end

    def from_json(string)
      from_h(Hash[JSON.parse(string).map{|(k,v)| [k.to_sym,v]}])
    end

    def from_h(h, strict=false)
      hash = symbolize_keys(h)
      throw "Old script version" if strict && hash[:version] != NScript::Version
      context = NScript::Context.new

      @meta   = hash[:meta]
      graph   = symbolize_keys(hash[:document])

      graph[:logic].each do |node_def|
        node_def = symbolize_keys(node_def)
        context.add_node([node_def[:group], node_def[:name]].join("."), node_def)
      end

      graph[:variables].each do |node_def|
        node_def = symbolize_keys(node_def)
        context.add_var(node_def[:value], node_def)
      end

      context.guid         = graph[:guid]
      context.connections  = graph[:connections]
      context.variables.from_h(graph[:values])

      return context
    end
  end
end