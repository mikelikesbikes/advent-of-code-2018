class Diviner
  CLAY = "#".freeze
  def self.from_string(input)
    input
      .split("\n")
      .each_with_object({}) do |line, soil|
        parse_vein(line).each do |clay_position|
          soil[clay_position] = CLAY
        end
      end
      .yield_self { |soil| new(soil) }
  end

  def self.water_capacity(input)
    diviner = from_string(input)
    before = ""
    after = diviner.to_s
    i = 0
    while before != after
      #puts(i += 1)
      before = after
      500.times { diviner.flow }
      after = diviner.to_s
    end

    puts diviner.to_s

    diviner.water_volumn
  end

  def self.parse_vein(str)
    if match = str.match(/^x=(\d+), y=(\d+)\.\.(\d+)$/)
      x, ymin, ymax = match.to_a.slice(1..-1).map(&:to_i)
      (ymin..ymax).map { |y| [x, y] }
    elsif match = str.match(/^y=(\d+), x=(\d+)\.\.(\d+)$/)
      y, xmin, xmax = match.to_a.slice(1..-1).map(&:to_i)
      (xmin..xmax).map { |x| [x, y] }
    end
  end

  attr_reader :soil, :stream

  def initialize(soil)
    @soil = soil
    @stream = Stream.new(@soil, bounds)
  end

  def flow
    stream.flow
    puts to_s
    puts "\n=========================\n"
  end

  def to_s
    xs, ys = bounds
    ys.map { |y| xs.map { |x| soil[[x, y]] || "." }.join }.join("\n")
  end

  def water_volumn
    xs, ys = bounds

    soil.count do |(x, y), v|
      v != CLAY && xs.include?(x) && ys.include?(y)
    end - 1
  end

  def bounds
    return @bounds if @bounds
    minx, maxx = @soil.keys.map { |x, _| x }.minmax
    x_range = Range.new(minx - 1, maxx + 1)
    y_range = Range.new(0, @soil.keys.map { |_, y| y }.max)
    @bounds = [x_range, y_range]
  end

  class Stream
    def initialize(soil, bounds, source = [500, 0])
      @soil = soil
      @leaves = [Node.new(source, nil)]
      @soil[source] = "+"
    end

    def flow
      @leaves = leaves.reduce([]) do |acc, node|
        acc.concat(node.extend(soil))
      end
    end

    private

    attr_reader :leaves, :soil

    class Node
      attr_accessor :parent, :pos
      attr_reader :children

      def initialize(pos, parent)
        @pos = pos
        @parent = parent
        @down = false
        @children = []
      end

      def move_left
        self.pos[0] -= 1
      end

      def move_up
        self.pos[1] -= 1
      end

      def move_right
        self.pos[0] += 1
      end

      def move_down
        self.pos[1] += 1
      end

      def inspect
        "#<Stream::Node pos=#{pos.inspect}>"
      end

      def split(pos)
        Node.new(pos, self).tap do |node|
          self.children << node
        end
      end

      def join(node)
        self.children.delete(node)
      end

      def extend(map)
        x, y = pos
        below = [x, y + 1]
        left = [x - 1, y]
        right = [x + 1, y]

        new_leaves = []
        if !map[below]
          new_leaves << split(below)
        elsif !map[left] || !map[right]
          new_leaves << split(left) if !map[left]
          new_leaves << split(right) if !map[right]
        else
          parent.join(self)
          #don't go up unless walls on both sides
          i = 0
          lwall = rwall = false
          lopen = ropen = false
          until (lwall || lopen) && (rwall || ropen)
            p [pos, i, map[[x-i,y]], map[[x+i,y]], lwall, lopen, rwall, ropen]
            i += 1
            case map[[x - i, y]]
            when "#" then lwall = true
            when nil then lopen = true
            end
            case map[[x + i, y]]
            when "#" then rwall = true
            when nil then ropen = true
            end
            raise "WTF" if i > 1000
          end
          require 'pry'; binding.pry if x == 500
          new_leaves << parent if parent.children.empty? && lwall && rwall
        end

        new_leaves.each { |node| map[node.pos] = "|" }
      end
    end
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

puts Diviner.water_capacity(input)
