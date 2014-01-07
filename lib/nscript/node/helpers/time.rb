module NScript::Node::Helpers::Time
  # Runs block in not distant future(about 1 ms)
  def future(&block)
    @context.backend.future(&block)
  end

  # delay execution of code using backend
  def delay(time)
    @context.backend.delay(time)
  end
end