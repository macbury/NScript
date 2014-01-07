require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NScript::Node::Variable do

  it "should allow to assign other variable node and read its value" do
    NScript.node(:test) {
      var :test, type: String, default: "foo"

      start do

      end
    }

    context    = NScript::Context.new

    var_node   = context.add_var({ type: String, default: "bar" })
    event_node = context.add_node("base.test")

    event_node.var.test.should eq("foo")
    context.assign(var_node, event_node, :test)
    event_node.var.test.should eq("bar")

    context.unassign(event_node, :test)
    event_node.var.test.should eq("foo")

    var_node.write("test")
    context.assign(var_node, event_node, :test)
    event_node.var.test.should eq("test")
    event_node.var.connected?(:test).should be_true

    second_event_node = context.add_node("base.test")
    context.assign(var_node, second_event_node, :test)
    second_event_node.var.test.should eq("test")

    var_node.write("fubar")
    second_event_node.var.test.should eq(event_node.var.test)

    context.remove(var_node)
    second_event_node.var.test.should eq("foo")
    event_node.var.test.should eq("foo")
  end
end