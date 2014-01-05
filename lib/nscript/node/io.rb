module NScript::Node
  class IO
    def initialize(node, name, output=false)
      @name     = name
      @output   = output
      @guid     = [node.guid, @output ? "output" : "input", name].join(".")
    end

    def out?
      @output
    end

    def in?
      !@output
    end

    def guid
      @guid
    end
  end
end