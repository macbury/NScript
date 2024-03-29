require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class ErrorDummyReciver
  def error!(payload)
    
  end
end

describe NScript::Context do
  before(:each) { NScript.nodes.clear! }
  
  it "should trigger add notification" do
    NScript.node(:test) {}

    recived_payload   = nil
    context   = NScript::Context.new
    context.notifications.on("graph.node.add", self) do |payload|
      recived_payload = payload
    end
    
    node = context.add_node("base.test")
    recived_payload.should_not be_nil
    recived_payload[:guid].should_not be_nil

    recived_payload[:guid].should eq(node.guid)
  end

  it "should found node by guid" do
    NScript.node(:test) {}

    context   = NScript::Context.new
    node      = context.add_node("base.test")

    context.get(node.guid).should be(node)
  end

  it "should allow connecting of nodes" do
    NScript.node(:test) {
      input  :input
      output :output
    }

    context   = NScript::Context.new
    a         = context.add_node("base.test")
    b         = context.add_node("base.test")

    input  = a.io.get_input(:input)
    output = b.io.get_output(:output)

    context.connect(output, input)
    context.notifications.should_receive(:trigger).with(input.guid, {}).exactly(1)
    context.trigger_output(output.guid)
  end

  it "should run node code" do
    NScript.node(:a) {
      output :foo
    }

    NScript.node(:b) {
      input  :bar

      run { |payload| }
    }

    context   = NScript::Context.new
    a         = context.add_node("base.a")
    b         = context.add_node("base.b")

    a_output  = a.io.get_output(:foo)
    b_input   = b.io.get_input(:bar)

    context.connect(a_output, b_input)
    b.should_receive(:run).with({}).exactly(1)
    context.trigger_output(a_output.guid)
  end

  it "should disconnect node" do
    NScript.node(:test) {
      input :bar
      output :foo
    }

    context   = NScript::Context.new
    a         = context.add_node("base.test")
    b         = context.add_node("base.test")

    a_output  = a.io.get_output(:foo)
    b_input   = b.io.get_input(:bar)

    context.connect(a_output, b_input)
    context.connected?(a_output, b_input).should be_true

    context.disconnect(a_output, b_input)
    context.connected?(a_output, b_input).should be_false
  end

  it "should trigger last node" do
    pay = { a: "b" }

    NScript.node(:a) {
      output :foo
    }

    NScript.node(:b) {
      input  :bar
      output :buzz
      run { |payload| io.write(:buzz, pay) }
    }

    context   = NScript::Context.new
    a         = context.add_node("base.a")
    b         = context.add_node("base.b")
    c         = context.add_node("base.b")

    a_output  = a.io.get_output(:foo)
    b_input   = b.io.get_input(:bar)
    b_output  = b.io.get_output(:buzz)
    c_input   = c.io.get_input(:bar)

    context.connect(a_output, b_input)
    context.connect(b_output, c_input)

    c.should_receive(:run).with(pay).exactly(1)
    context.trigger_output(a_output.guid)
  end

  it "should trigger few nodes" do
    NScript.node(:a) {
      output :foo
    }

    NScript.node(:b) {
      input  :bar
      output :buzz
      run { |payload| io.write(:buzz, payload) }
    }

    context   = NScript::Context.new
    a         = context.add_node("base.a")
    b         = context.add_node("base.b")
    c         = context.add_node("base.b")

    a_output  = a.io.get_output(:foo)
    b_input   = b.io.get_input(:bar)
    c_input   = c.io.get_input(:bar)

    context.connect(a_output, b_input)
    context.connect(a_output, c_input)

    b.should_receive(:run).with({}).exactly(1)
    c.should_receive(:run).with({}).exactly(1)
    context.trigger_output(a_output.guid)
  end

  it "should remove node" do
    NScript.node(:a) {
      output :foo
    }

    NScript.node(:b) {
      input  :bar
      output :buzz

      var :test

      run { |payload| io.write(:buzz, payload) }
    }


    context   = NScript::Context.new
    a         = context.add_node("base.a")
    b         = context.add_node("base.b")
    c         = context.add_node("base.b")

    a_output  = a.io.get_output(:foo)
    b_input   = b.io.get_input(:bar)
    b_output  = b.io.get_output(:buzz)
    c_input   = c.io.get_input(:bar)

    context.connect(a_output, b_input)
    context.connect(b_output, c_input)

    var_names    = context.variables.keys
    events_names = context.notifications.events

    context.remove(b)
    b.should_receive(:run).exactly(0)
    c.should_receive(:run).exactly(0)
    context.trigger_output(a_output.guid)

    context.get(b.guid).should be_nil
    var_names.should_not       be(context.variables.keys)
    events_names.should_not    be(context.notifications.events)
  end

  it "should trigger node after start context" do
    NScript.node(:a) {
      output :foo

      start do 
        io.write(:foo) 
      end
    }

    NScript.node(:b) {
      input  :bar
      output :buzz

      var :test

      run { |payload| io.write(:buzz, payload) }
    }

    context   = NScript::Context.new
    a         = context.add_node("base.a")
    b         = context.add_node("base.b")
    c         = context.add_node("base.b")

    a_output  = a.io.get_output(:foo)
    b_input   = b.io.get_input(:bar)
    b_output  = b.io.get_output(:buzz)
    c_input   = c.io.get_input(:bar)

    context.connect(a_output, b_input)
    context.connect(b_output, c_input)
    c.should_receive(:run).exactly(1)

    context.start
  end

  it "should trigger error callback if there is error in node" do
    NScript.node(:a) {
      output :foo
      start { throw "test" }
    }

    context   = NScript::Context.new
    a         = context.add_node("base.a")

    dummy_error = ErrorDummyReciver.new
    context.notifications.on("graph.error", self) do |payload|
      dummy_error.error!(payload)
      payload[:guid].should_not be_nil
      context.get(payload[:guid]).should_not be_nil
      payload[:error].should_not be_nil
    end

    dummy_error.should_receive(:error!).exactly(1)
    context.start
  end
end