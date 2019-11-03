class FixedPoints
  attr_reader :points

  def initialize(points)
    @points = points
  end

  def constellations
    graph = Hash.new { |h,k| h[k] = [] }
    points.each_with_index do |a, i|
      graph[a] ||= []
      points.slice(i + 1..-1).each do |b|
        if distance(a, b) <= 3
          graph[a] << b
          graph[b] << a
        end
      end
    end

    constellations = graph.each_with_object([]) do |(point, edges), constellations|
      # skip the point if we've already put it in a constellation
      next if constellations.any? { |c| c.include?(point) }

      constellation = [point]
      to_visit = edges
      while to_visit.length > 0
        constellation.concat(to_visit)
        to_visit = to_visit.flat_map { |p| graph[p] }.reject { |p| constellation.include?(p) }
      end

      constellations << constellation
    end
    constellations
  end

  private

  def distance(a, b)
    a.zip(b).sum { |c, d| (c - d).abs }
  end

  def self.from_string(str)
    str
      .split("\n")
      .map { |line| line.split(",").map(&:to_i) }
      .yield_self { |points| new(points) }
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

puts FixedPoints.from_string(input).constellations.length
