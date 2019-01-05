require_relative "../lib/priority_queue"

class Formation
  attr_reader :nanobots
  def initialize(nanobots)
    @nanobots = nanobots
  end

  def self.from_input(str)
    str
      .split("\n")
      .map { |line| Nanobot.from_str(line) }
      .yield_self { |nanobots| new(nanobots) }
  end

  def in_range_of_strongest
    strongest = nanobots.max_by(&:range)
    in_range_of(strongest)
  end

  def in_range_of(bot_or_pos)
    if Nanobot === bot_or_pos
      nanobots.count { |bot| bot_or_pos.in_range_of?(bot) }
    else
      nanobots.count { |bot| bot.in_range_of?(bot_or_pos) }
    end
  end

  def optimal_teleportation_position(threshold = @nanobots.length, bounds = bounds)
    candidate_locations = PriorityQueue.new do |count, bounds|
      [[0, count - 898].max, volume(bounds) * (count ** 6)]
    end

    min_bounds = bounds ||= self.bounds
    min_dist = Formation.distance([0,0,0], center(bounds))
    max_in_range = in_range_of(center(bounds))

    candidate_locations << [max_in_range, bounds]

    while (in_range, bounds = candidate_locations.pop) && in_range < threshold
      center = center(bounds)
      if in_range >= max_in_range
        dist = Formation.distance([0,0,0], center(bounds))
        if in_range > max_in_range
          max_in_range = in_range
          min_bounds = bounds
          min_dist = dist
        else
          min_dist = dist if dist < min_dist
        end
      end
      p volume(bounds), center(min_bounds), min_dist, max_in_range
      puts "====="

      new_ranges = split(bounds)
      new_ranges.each do |new_bounds|
        candidate_locations << [in_range_of(center(new_bounds)), new_bounds]
      end
    end

    if bounds
      Formation.distance([0,0,0], center(bounds))
    else
      min_dist
    end
  end

  def volume(ranges)
    ranges.reduce(1) { |acc, range| acc * (range.end - range.begin + 1) }
  end

  def split(bounds)
    xs, ys, zs = bounds
    x, y, z = center(bounds)
    midx = (xs.end + xs.begin + 1) / 2
    midy = (ys.end + ys.begin + 1) / 2
    midz = (zs.end + zs.begin + 1) / 2
    lowx = Range.new(xs.begin, midx - 1)
    highx = Range.new(midx, xs.end)
    lowy = Range.new(ys.begin, midy - 1)
    highy = Range.new(midy, ys.end)
    lowz = Range.new(zs.begin, midz - 1)
    highz = Range.new(midz, zs.end)
    [
      [lowx, lowy, lowz],
      [lowx, lowy, highz],
      [lowx, highy, lowz],
      [lowx, highy, highz],
      [highx, lowy, lowz],
      [highx, lowy, highz],
      [highx, highy, lowz],
      [highx, highy, highz]
    ].select do |ranges|
      ranges.all? { |range| (range.end - range.begin) >= 0 } && ranges != bounds
    end
  end

  #def optimal_teleportation_position(threshold = 1000)
  #  x, y, z = max_coord = [0, 0, 0]
  #  max_in_range = in_range_of(max_coord)
  #  (0..threshold).each do |xdiff|
  #    (0..(threshold - xdiff)).each do |ydiff|
  #      (0..(threshold - xdiff - ydiff)).each do |zdiff|
  #        [
  #          [x - xdiff, y - ydiff, z - zdiff],
  #          [x - xdiff, y - ydiff, z + zdiff],
  #          [x - xdiff, y + ydiff, z - zdiff],
  #          [x - xdiff, y + ydiff, z + zdiff],
  #          [x + xdiff, y - ydiff, z - zdiff],
  #          [x + xdiff, y - ydiff, z + zdiff],
  #          [x + xdiff, y + ydiff, z - zdiff],
  #          [x + xdiff, y + ydiff, z + zdiff]
  #        ].each do |pos|
  #          in_range = in_range_of(pos)
  #          if in_range > max_in_range
  #            max_in_range = in_range
  #            max_coord = pos
  #          end
  #        end
  #      end
  #    end
  #  end
  #  max_coord
  #  Formation.distance([0, 0, 0], max_coord)
  #end

  def center((xs, ys, zs))
    midx = (xs.end + xs.begin + 1) / 2
    midy = (ys.end + ys.begin + 1) / 2
    midz = (zs.end + zs.begin + 1) / 2
    [midx, midy, midz]
  end

  def bounds
    first, *rest = @nanobots.map(&:pos)
    first
      .zip(*rest)
      .map { |cs| Range.new(*cs.minmax) }
  end

  class Nanobot
    attr_reader :range, :pos

    def initialize(pos, range)
      @pos = pos
      @range = range
    end

    def self.from_str(str)
      x, y, z, range = str.match(/pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)/).captures.map(&:to_i)
      new([x, y, z], range)
    end

    def in_range_of?(other)
      distance_to(other) <= range
    end

    def distance_to(other)
      other_pos = Nanobot === other ? other.pos : other
      Formation.distance(pos, other_pos)
    end

    def overlapping_ranges?(other)
      distance_to(other) <= (range + other.range)
    end
  end

  def self.distance(a, b)
    a.zip(b).sum { |a, b| (a - b).abs }
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

formation = Formation.from_input(input)
puts formation.in_range_of_strongest
puts formation.optimal_teleportation_position(908)
