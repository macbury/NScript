require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NScript do
  before(:each) { NScript.reset! }

  it "should add new node" do
    NScript.node(:test) {}
    NScript.nodes.size.should > 0
  end

  it "should only have one node" do
    NScript.node(:test) {}
    NScript.node(:test) {}
    NScript.nodes.size.should == 1
  end

  it "should throw exception about un found node" do
    context   = NScript::Context.new
    expect { context.add("base.test") }.to raise_error(NScript::NodeBuilder::NodeNotFound)
  end

  it "should define new example node without callbacks" do
    NScript.node(:test) {}

    context   = NScript::Context.new
    test_node = context.add("base.test")
    test_node.should_not be_nil

    test_node.name.should eq(:test)

    test_node.run_callback?.should   eq(false)
    test_node.start_callback?.should eq(false)
    test_node.stop_callback?.should  eq(false)
  end

  it "should define new example node with variables" do
    NScript.node :foo do
      var :bar,  type: Integer, default: -2
      var :foo,  type: String,  default: "Hello"
      var :buzz, type: Boolean, default: true
    end

    context   = NScript::Context.new
    test_node = context.add("base.foo")

    test_node.var.bar.should  eq(-2)
    test_node.var.foo.should  eq("Hello")
    test_node.var.buzz.should eq(true)

    test_node.var.bar = 3
    test_node.var.bar.should  eq(3)

    test_node.var.bar = "ssss"
    test_node.var.bar.should  eq(0)
  end
end