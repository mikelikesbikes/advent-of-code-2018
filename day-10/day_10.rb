module MessageFinder
  def run(input)
    input
      .map { |line| parse_point_of_light(line) }
      .yield_self do |points_of_light|
        next_area = 2**32 * 2**32
        n = 0
        n += 1 while (current_area = next_area) > (next_area = covered_area(points_of_light_at_tick(points_of_light, n)))
        n -= 1

        [n, plot_message(points_of_light_at_tick(points_of_light, n))]
      end
  end

  def covered_area(pol)
    xs, ys = bounds(pol)
    xs.size * ys.size
  end

  def bounds(pol)
    xs = Range.new(*pol.map(&:first).minmax)
    ys = Range.new(*pol.map(&:last).minmax)
    [xs, ys]
  end

  def points_of_light_at_tick(pol, n)
    pol.map do |(x, y), vel|
      [x + (n * vel.first), y + (n * vel.last)]
    end
  end

  def plot_message(pol)
    x_range, y_range = bounds(pol)
    pol_hash = Hash[pol.zip([true]*pol.size)]
    y_range.map do |y|
      x_range.map do |x|
        pol_hash[[x, y]] ? "#" : "."
      end.join
    end.join("\n")
  end

  def parse_point_of_light(str)
    _, position_str, velocity_str = str.match(/position=<(.*)> velocity=<(.*)>/).to_a
    x, y = position_str.split(",").map(&:strip).map(&:to_i)
    dx, dy = velocity_str.split(",").map(&:strip).map(&:to_i)
    [[x, y], [dx, dy]]
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip.split("\n")

puts MessageFinder.run(input)
