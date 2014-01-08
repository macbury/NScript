require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe NScript::Persister do
  it "should proper save and load it" do
    context   = ContextBuilder.build_with_three_connected_nodes_and_var
    #NScript::Logger.new(context)
    context.start
    #puts "=-=-=--=-=-=-=-=-=-=-"
    persister = NScript::Persister::Save.new(context)

    json      = persister.to_json
    persister.save("test.nscript")
    loader    = NScript::Persister::Load.new
    new_context = loader.from_json(json)
    #NScript::Logger.new(new_context)
    new_context.start
    
    context.connections.should          eq(new_context.connections)
    context.nodes.keys.sort.should      eq(new_context.nodes.keys.sort)
    context.variables.keys.sort.should  eq(new_context.variables.keys.sort)
  end
end