class TestRuntime
  def stack
    @stack ||= []
  end

  def push(*elements)
    stack.push *elements
  end
end
