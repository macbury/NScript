module NScript
  def self.node(name, group=:base, &block)
    node = NScript::NodeBuilder::Base.new(:base, name)
    Docile.dsl_eval(node, &block)
    NScript.nodes.add(node)
  end

  def self.event(name, &block)
    node(name, :event, &block)
  end

  def self.action(name, &block)
    node(name, :action, &block)
  end

  def self.condition(name, &block)
    node(name, :condition, &block)
  end

  def self.variable(name, &block)
    throw "Unimplemented"
  end

  def self.nodes
    @manager ||= NScript::NodeBuilder::Manager.new
  end
end