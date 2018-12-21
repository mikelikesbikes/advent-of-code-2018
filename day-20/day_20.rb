module NorthPole
  class Map
    def initialize(root)
      @root = root
    end

    def longest_path
      @root.longest_path
    end

    def paths_with_at_least_n_steps(n)
      @root.paths_with_at_least_n_steps(n)
    end

    def self.from_regex(str)
      remove_empty_options(str)
      str.slice!(/^\^/)
      self.new(Node.from_str(str))
    end

    def self.remove_empty_options(str)
      begin
        original_length = str.length
        empty_options = %w[
          NS
          SN
          EW
          WE
        ]
        str.gsub!(Regexp.union(empty_options), "")
        str.gsub!(/\([|]+\)/, "")
      end until original_length == str.length
    end

    class Node
      attr_reader :str, :children

      def initialize(str)
        @str = str
        @children = []
      end

      def add_child(child)
        children << child
      end

      def self.from_str(str)
        lstr = str.slice!(/^[NESW]+/)
        node = self.new(lstr.to_s)

        if str[0] == "("
          char = str.slice!(0, 1)
          while str.length > 0 && char != ")"
            child = self.from_str(str)
            node.add_child(child)
            char = str.slice!(0, 1)
          end
        end

        node
      end

      def longest_path
        str.length + children.map(&:longest_path).max.to_i
      end

      def paths_with_at_least_n_steps(n)
        reachable_children = children.sum { |child| child.paths_with_at_least_n_steps(n - str.length) }
        (n > str.length) ? reachable_children : reachable_children + (str.length - (n - 1))
      end
    end
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

map = NorthPole::Map.from_regex(input)

puts map.longest_path
puts map.paths_with_at_least_n_steps(1000)
