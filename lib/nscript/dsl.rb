module NScript
  def self.node(name, &block)
    node = NScript::NodeBuilder::Base.new(:base, name)
    Docile.dsl_eval(node, &block)
    NScript.nodes.add(node)
  end

  def self.nodes
    @manager ||= NScript::NodeBuilder::Manager.new
  end
end