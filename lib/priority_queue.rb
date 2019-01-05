
class PriorityQueue
  attr_reader :elements

  def initialize(&block)
    @elements = [nil]
    @block = block
  end

  def <<(element)
    @elements << element
    bubble_up(@elements.size - 1)
  end

  def pop
    exchange(1, @elements.size - 1)
    max = @elements.pop
    bubble_down(1)
    max
  end

  def peek
    @elements[1]
  end

  def empty?
    @elements.length <= 1
  end

  private

  def bubble_up(index)
    parent_index = (index / 2)

    return if index <= 1
    return if gte(@elements[parent_index], @elements[index])

    exchange(index, parent_index)
    bubble_up(parent_index)
  end

  def bubble_down(index)
    child_index = (index * 2)

    return if child_index > @elements.size - 1

    not_the_last_element = child_index < @elements.size - 1
    left_element = @elements[child_index]
    right_element = @elements[child_index + 1]
    child_index += 1 if not_the_last_element && gt(right_element, left_element)

    return if gte(@elements[index], @elements[child_index])

    exchange(index, child_index)
    bubble_down(child_index)
  end

  def exchange(source, target)
    @elements[source], @elements[target] = @elements[target], @elements[source]
  end

  def gt(left, right)
    (@block.call(left) <=> @block.call(right)) > 0
  end

  def gte(left, right)
    (@block.call(left) <=> @block.call(right)) >= 0
  end
end
