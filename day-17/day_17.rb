require "set"

class Diviner
  def self.from_string(input)
    input
      .split("\n")
      .each_with_object(Hash.new(OPEN)) do |line, soil|
        parse_vein(line).each do |clay_position|
          soil[clay_position] = CLAY
        end
      end
      .yield_self { |soil| new(soil) }
  end

  def initialize(soil)
    @soil = soil
    @soil_bounds = bounds
    @ymax = @soil_bounds.last.max
    @water = Set.new
    @soil[[500, 0]] = START
    fill(500, 0)
  end

  def water_capacity
    xs, ys = bounds
    @soil.count do |(x, y), v|
      ys.include?(y) &&
        [FLOWING, SETTLED].include?(v)
    end
  end

  def retained_capacity
    @soil.count do |_, v|
      v == SETTLED
    end
  end

  def to_s
    xs, ys = bounds
    (0..ys.max).map { |y| xs.map { |x| soil.fetch([x, y], ".") }.join }.join("\n")
  end

  private

  def self.parse_vein(str)
    if match = str.match(/^x=(\d+), y=(\d+)\.\.(\d+)$/)
      x, ymin, ymax = match.to_a.slice(1..-1).map(&:to_i)
      (ymin..ymax).map { |y| [x, y] }
    elsif match = str.match(/^y=(\d+), x=(\d+)\.\.(\d+)$/)
      y, xmin, xmax = match.to_a.slice(1..-1).map(&:to_i)
      (xmin..xmax).map { |x| [x, y] }
    end
  end

  attr_reader :soil

  DOWN = [0, 1]
  LEFT = [-1, 0]
  RIGHT = [1, 0]
  UP = [0, -1]
  CLAY = "#"
  OPEN = "."
  FLOWING = "|"
  SETTLED = "~"
  START = "+"

  def sample(*pos)
    @soil[pos]
  end

  def fill(*pos)
    x,y = pos
    return if y > @ymax
    if sample(x, y+1) == OPEN
      @soil[[x, y+1]] = FLOWING
      fill(x, y+1)
    end
    if [CLAY, SETTLED].include?(sample(x, y+1)) && sample(x+1, y) == OPEN
      @soil[[x+1, y]] = FLOWING
      fill(x+1, y)
    end
    if [CLAY, SETTLED].include?(sample(x, y+1)) && sample(x-1, y) == OPEN
      @soil[[x-1, y]] = FLOWING
      fill(x-1, y)
    end
    if both_walls?(x, y)
      settle_level(x, y)
    end
  end

  def both_walls?(*pos)
    has_wall?(pos, -1) && has_wall?(pos, 1)
  end

  def has_wall?(pos, offset)
    x,y = pos
    while true
      case sample(x, y)
      when CLAY then return true
      when OPEN then return false
      else x += offset
      end
    end
  end

  def settle_side((x,y), offset)
    while true
      return if sample(x, y) == CLAY
      soil[[x, y]] = SETTLED
      x += offset
    end
  end

  def settle_level(*pos)
    settle_side(pos, -1)
    settle_side(pos, 1)
  end

  def bounds
    return @bounds if @bounds
    minx, maxx = @soil.keys.map { |x, _| x }.minmax
    miny, maxy = @soil.keys.map { |_, y| y }.minmax
    x_range = Range.new(minx - 1, maxx + 1)
    y_range = Range.new(miny, maxy)
    @bounds = [x_range, y_range]
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

diviner = Diviner.from_string(input)
puts diviner.water_capacity
puts diviner.retained_capacity
