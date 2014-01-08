module ContextBuilder
  
  def self.build_with_three_connected_nodes_and_var
    NScript.node(:a) {
      output :foo

      start { execute! }
      run { |payload| io.write(:foo) }
    }

    NScript.node(:b) {
      input  :bar
      output :buzz
      run { |payload| io.write(:buzz, payload) }
    }

    NScript.node(:test) {
      var :test, type: String, default: "foo"

      start do
        
      end
    }

    context   = NScript::Context.new
    a         = context.add_node("base.a")
    b         = context.add_node("base.b")
    c         = context.add_node("base.b")

    var_node   = context.add_var({ type: String, default: "bar" })
    event_node = context.add_node("base.test")
    context.assign(var_node, event_node, :test)

    a_output  = a.io.get_output(:foo)
    b_input   = b.io.get_input(:bar)
    c_input   = c.io.get_input(:bar)

    context.connect(a_output, b_input)
    context.connect(a_output, c_input)

    context
  end

end