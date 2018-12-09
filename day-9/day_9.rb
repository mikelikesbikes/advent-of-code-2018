module Circle
  class Node
    attr_reader :value
    attr_accessor :next, :prev

    def initialize(value, cw = self, ccw = self)
      @value = value
      self.next = cw
      self.prev = ccw
    end

    def insert_after(data)
      Node.new(data).tap do |new_node|
        new_node.prev = self
        new_node.next = self.next
        self.next.prev = new_node
        self.next = new_node
      end
    end

    def inspect
      "#<Node value=#{value} next=#{self.next.value} prev=#{self.prev.value}>"
    end

    def delete
      self.tap do |node|
        node.prev.next = node.next
        node.next.prev = node.prev
      end
    end
  end
end

class MarbleGame
  attr_reader :num_players, :last_marble

  def initialize(num_players, last_marble)
    @num_players = num_players
    @last_marble = last_marble
  end

  def winning_score
    scores = Hash.new(0)
    zero_node = current_node = Circle::Node.new(0)
    1.upto(last_marble).with_index do |value, i|
      player_id = (i % num_players) + 1
      if value % 23 == 0
        scoring_node = 7.times.reduce(current_node) { |node, i| node.prev }.delete
        scores[player_id] += (value + scoring_node.value)
        current_node = scoring_node.next
      else
        current_node = current_node.next.insert_after(value)
      end
    end
    scores.values.max
  end

  private

  def print_circle(starting_node)
    print "%d " % starting_node.value

    node = starting_node.next
    while node != starting_node
      print "%d " % node.value
      node = node.next
    end
    puts
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

/(\d+) players; last marble is worth (\d+) points/ =~ input

num_players = $1.to_i
last_marble = $2.to_i

puts MarbleGame.new(num_players, last_marble).winning_score
puts MarbleGame.new(num_players, last_marble * 100).winning_score
