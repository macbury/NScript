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

    a.guid.should match(/base\.foo\.\d+/i)
    b.guid.should match(/base\.test\.\d+/i)
    
  end

end