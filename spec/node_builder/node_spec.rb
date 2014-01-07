require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NScript::Node::Base do

  it "should always have guid initialized" do
    NScript.node(:test) {}
    NScript.node(:foo) {}
    context = NScript::Context.new
    a = context.add("base.test")
    b = context.add("base.test")
     
    a.guid.should_not be_nil
    b.guid.should_not be_nil

    a = context.add("base.foo")
    a.guid.should_not eq(b.guid)

    a.guid.should match(/base\.foo\.node\.\d+/i)
    b.guid.should match(/base\.test\.node\.\d+/i)
  end

  it "should have proper variable key name node_name.node_id.var.var_name" do
    NScript.node(:test) {
      var :hello
    }
    context = NScript::Context.new

    a = context.add("base.test")
    a.var.hello_key.should match(/base\.test\.node\.\d+\.var\.hello/)
  end

  it "should have inputs" do
    NScript.node(:test) {
      var    :hello
      output :foo
      input  :bar
    }
    context = NScript::Context.new

    a = context.add("base.test")
    a.io.inputs.size.should eq(1)
    a.io.outputs.size.should eq(1)
  end
end