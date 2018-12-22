module NorthPole
  class Map
    def initialize(map, distances)
      @map = map
      @distances = distances
    end

    def longest_path
      @distances.values.max
    end

    def paths_with_at_least_n_steps(n)
      @distances.values.count { |v| v >= n }
    end

    def self.from_regex(str)
      rooms = []
      room = [0, 0]
      map = Hash.new { |h, k| h[k] = [] }
      distances = Hash.new
      directions = {
        "N" => [0, -1],
        "E" => [1, 0],
        "S" => [0, 1],
        "W" => [-1, 0]
      }

      str.chars.each do |c|
        case c
        when "^", "$"
          next
        when "("
          rooms.push(room)
        when ")"
          room = rooms.pop
        when "|"
          room = rooms.last
        when "N", "E", "S", "W"
          new_room = room.zip(directions[c]).map(&:sum)
          map[new_room] << room
          new_distance = distances.fetch(room, 0) + 1
          current_distance = distances.fetch(new_room, nil)
          distances[new_room] = new_distance if !current_distance || new_distance < current_distance
          room = new_room
        end
      end

      new(map, distances)
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
