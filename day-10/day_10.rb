module MessageFinder
  def run(input)
    points_of_light = input.map { |line| parse_point_of_light(line) }
    n = find_convergance_time(points_of_light)
    [n, plot_message(points_of_light_at_tick(points_of_light, n))]
  end

  def find_convergance_time(points_of_light, n = 0, m = 20_000)
    return m if m - n <= 1
    narea = covered_area_at_tick(points_of_light, n)
    marea = covered_area_at_tick(points_of_light, m)
    if narea < marea
      find_convergance_time(points_of_light, n, (m + n) / 2)
    else
      find_convergance_time(points_of_light, (m + n) / 2, m)
    end
  end

  def covered_area_at_tick(pol, n)
    xs, ys = bounds(points_of_light_at_tick(pol, n))
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
