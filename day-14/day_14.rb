class Kitchen
  attr_reader :recipes, :elf1, :elf2
  def initialize(initial_recipes = [3, 7])
    @recipes = RecipeList.new(*initial_recipes)
    @elf1 = @recipes.head
    @elf2 = @recipes.tail
  end

  def recipe_scores
    @recipes.scores
  end

  def tick(&block)
    loop do
      (elf1.score + elf2.score)
        .to_s
        .chars
        .each do |c|
          @recipes.append(c.to_i)
          yield self if block_given?
        end
      (elf1.score + 1).times { @elf1 = elf1.next }
      (elf2.score + 1).times { @elf2 = elf2.next }
      return
    end
  end

  def make(n)
    tick while recipes.length < n
    self
  end

  def make_until_score_sequence(sequence)
    found_position = nil
    until found_position
      tick do |k|
        if k.recipes.length >= sequence.length && k.recipes.last_scores(sequence.length) == sequence
          found_position = recipes.length - sequence.length
        end
      end
    end
    found_position
  end

  class RecipeList
    attr_reader :head, :tail, :length

    def initialize(r1, r2)
      node1 = Node.new(r1)
      node2 = Node.new(r2)
      node1.next = node2
      node1.prev = node2
      node2.next = node1
      node2.prev = node1

      @head = node1
      @tail = node2

      @length = 2
    end

    def append(score)
      Node.new(score).tap do |new_tail|
        new_tail.next = @tail.next
        new_tail.prev = @tail
        new_tail.next.prev = new_tail
        @tail.next = new_tail

        @tail = new_tail

        @length += 1
      end
    end

    def last_scores(n)
      scores = []
      node = tail
      n.times do
        scores.unshift(node.score)
        node = node.prev
      end
      scores.join
    end

    def scores
      scores = [head.score]
      node = head.next
      while node != head
        scores << node.score
        node = node.next
      end
      scores
    end

    class Node
      attr_accessor :next, :prev
      attr_reader :score

      def initialize(score)
        @score = score
      end
    end
  end
end

return unless $PROGRAM_NAME == __FILE__

input = (ARGV.shift || "505961").to_i

kitchen = Kitchen.new
puts kitchen.make(input + 10).recipe_scores.slice(input, 10).join
puts kitchen.make_until_score_sequence(input.to_s)
