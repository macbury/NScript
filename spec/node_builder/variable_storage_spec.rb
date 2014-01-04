require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NScript::VariableStorage do

  it "should throw exceptions for empty vars" do
    storage = NScript::VariableStorage.new

    expect { storage.write("test", 0) }.to raise_error(NScript::VarNotFound)
    expect { storage.read("test") }.to     raise_error(NScript::VarNotFound)
    expect { storage.type_of("test") }.to  raise_error(NScript::VarNotFound)
  end

  it "should give ability to store values" do
    storage = NScript::VariableStorage.new

    storage.setup("foo.bar", NScript::Var::Integer.new(0))

    storage.read("foo.bar").should eq(0)
    storage.write("foo.bar", 3)
    storage.read("foo.bar").should eq(3)
  end

end