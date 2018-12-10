module MessageFinder
  def run(input)
    input
      .map { |line| parse_point_of_light(line) }
      .yield_self do |points_of_light|
        area1 = 2**32 * 2**32
        area2 = covered_area(points_of_light)

        pol1 = nil
        pol2 = points_of_light

        n = 0
        while area1 > area2
          pol1 = pol2
          area1 = area2
          pol2 = tick(pol1)
          area2 = covered_area(pol2)
          n += 1
        end

        [n - 1, plot_message(pol1)]
      end
  end

  def parse_point_of_light(str)
    _, position_str, velocity_str = str.match(/position=<(.*)> velocity=<(.*)>/).to_a
    x, y = position_str.split(",").map(&:strip).map(&:to_i)
    dx, dy = velocity_str.split(",").map(&:strip).map(&:to_i)
    [[x, y], [dx, dy]]
  end

  def covered_area(pol)
    xs, ys = bounds(pol)
    xs.size * ys.size
  end

  def bounds(pol)
    xs = Range.new(*pol.map { |((x, _), _)| x }.minmax)
    ys = Range.new(*pol.map { |((_, y), _)| y }.minmax)
    [xs, ys]
  end

  def tick(pol)
    pol.map do |(x, y), vel|
      [[x + vel.first, y + vel.last], vel]
    end
  end

  def plot_message(pol)
    x_range, y_range = bounds(pol)
    pol_hash = Hash[pol]
    y_range.map do |y|
      x_range.map do |x|
        pol_hash[[x, y]] ? "#" : "."
      end.join
    end.join("\n")
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip.split("\n")

puts MessageFinder.run(input)
