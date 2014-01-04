require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

class DummyContextObject
  def initialize
    @test_var = 1
  end

  def test_var
    @test_var
  end
end

describe NScript::Notifications do

  it "should allow add actions and run it in proper context" do
    dummy = DummyContextObject.new
    notifications = NScript::Notifications.new
    notifications.on(:test, dummy) { @test_var = 2 }
    notifications.count(:test).should eq(1)
    notifications.trigger(:test)

    dummy.test_var.should eq(2)
  end

  it "should remove events" do
    dummy         = DummyContextObject.new
    notifications = NScript::Notifications.new

    notifications.on(:test, dummy) { @test_var = 2 }
    notifications.count(:test).should eq(1)
    notifications.off(:test, dummy)
    notifications.count(:test).should eq(0)

    notifications.on(:test, dummy) {}
    notifications.on(:test, self)  {}

    notifications.count(:test).should eq(2)

    notifications.off(:test, dummy)
    notifications.count(:test).should eq(1)

    notifications.off(:test, self)
    notifications.count(:test).should eq(0)
  end

end