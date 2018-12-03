module FabricAnalyzer
  def pristine_claims(lines)
    read_claims(lines)
      .yield_self { |claims| [claims, build_claims_map(claims)] }
      .yield_self do |claims, claims_map|
        claim = claims.find do |claim|
          claim_coords(claim).all? { |coord| claims_map[coord] == 1 }
        end
        claim.first
      end
  end

  def overlap(lines)
    read_claims(lines)
      .yield_self { |claims| build_claims_map(claims) }
      .count { |_, v| v > 1 }
  end

  def read_claims(lines)
    lines.map { |line| parse(line) }
  end

  def build_claims_map(claims)
    claims.each_with_object(Hash.new(0)) do |claim, claims_map|
      claim_coords(claim).each do |coord|
        claims_map[coord] += 1
      end
    end
  end

  def claim_coords(claim)
    _, (x, y), (width, length) = claim
    width.times.each_with_object([]) do |i, coords|
      length.times do |j|
        coords << [x + i, y + j]
      end
    end
  end

  def parse(line)
    id, _, start, dimensions = line.split(" ")
    coord = start.slice(0..-2).split(",").map(&:to_i)
    width_length = dimensions.split("x").map(&:to_i)
    [id, coord, width_length]
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__

input = File.read(File.expand_path("input.txt", __dir__)).split("\n")

puts FabricAnalyzer.overlap(input)
puts FabricAnalyzer.pristine_claims(input)
