require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NScript::Node::IO do
  it "should build proper guid for input and output" do
    NScript.node(:test) {}

    recived_payload   = nil
    context           = NScript::Context.new
    node              = context.add("base.test")
    
    output = NScript::Node::IO.new(node, "test", true)
    output.guid.should match(/base\.test\.\d\.output\.test/i)

    input  = NScript::Node::IO.new(node, "test", false)
    input.guid.should match(/base\.test\.\d\.input\.test/i)
  end
end