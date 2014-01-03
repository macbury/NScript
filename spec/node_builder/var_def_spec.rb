require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NScript::NodeBuilder::VarDef do
  it "should create default number variable" do
    var = NScript::NodeBuilder::VarDef.new("test", {})

    var.name.should eq("test")
    var.type.should eq(Integer)
  end

  it "should create boolean variable" do 
    var = NScript::NodeBuilder::VarDef.new("test", { type: Boolean })
    var.type.should eq(Boolean)
    var.default.should eq(false)

    var = NScript::NodeBuilder::VarDef.new("test", { type: Boolean, default: true })
    var.default.should eq(true)
  end

  it "should create integer variable" do 
    var = NScript::NodeBuilder::VarDef.new("test", { type: Integer })
    var.type.should eq(Integer)
    var.default.should eq(0)

    var = NScript::NodeBuilder::VarDef.new("test", { type: Integer, default: 1 })
    var.default.should eq(1)
  end

  it "should create float variable" do 
    var = NScript::NodeBuilder::VarDef.new("test", { type: Float })
    var.type.should eq(Float)
    var.default.should eq(0.0)

    var = NScript::NodeBuilder::VarDef.new("test", { type: Float, default: 1.0 })
    var.default.should eq(1.0)
  end

  it "should create string variable" do 
    var = NScript::NodeBuilder::VarDef.new("test", { type: String })
    var.type.should eq(String)
    var.default.should eq("")

    var = NScript::NodeBuilder::VarDef.new("test", { type: String, default: "test" })
    var.default.should eq("test")
  end
end