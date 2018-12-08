require "time"

module LicenseCracker
  class Tree
    attr_reader :root

    def initialize(root)
      @root = root
    end

    def find_node(data)
      nodes.find { |node| node.data == data } ||
        Node.new(data).tap { |node| self.nodes << node }
    end

    def self.parse(input)
      Tree.new(Node.parse(input))
    end

    def metadata_sum
      root.metadata_sum
    end

    def value
      root.value
    end

    class Node
      attr_reader :children, :metadata

      def initialize(children, metadata)
        @children = children
        @metadata = metadata
      end

      def self.parse(input)
        child_count, metadata_count = input.shift(2)
        children = child_count.times.map do
          parse(input)
        end
        metadata = input.shift(metadata_count)
        new(children, metadata)
      end

      def metadata_sum
        children.reduce(metadata.sum) { |acc, node| acc + node.metadata_sum }
      end

      def value
        @value ||= metadata.sum do |metadata|
          if children.empty?
            metadata
          else
            index = metadata - 1
            index >= 0 && index < children.length ? children[index].value : 0
          end
        end
      end
    end
  end

  def parse_tree(input)
    input
      .split(" ")
      .map(&:to_i)
      .yield_self do |nums|
        Tree.parse(nums)
      end
  end

  def metadata_sum(input)
    parse_tree(input).metadata_sum
  end

  def calculate_value(input)
    parse_tree(input).value
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

puts LicenseCracker.metadata_sum(input)
puts LicenseCracker.calculate_value(input)
