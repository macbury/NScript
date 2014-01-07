require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NScript::Persister do
  it "should build proper guid for input and output" do
    NScript.node(:a) {
      output :foo
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

    persister = NScript::Persister::Save.new(context)
    persister.save("test.ns")
  end
end