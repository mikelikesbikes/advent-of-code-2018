require_relative "../lib/priority_queue"
require "set"

class CaveAnalyzer
  def initialize(depth, target)
    @depth = depth
    @target = target
  end

  def geologic_index(x, y)
    @geologic_index ||= Hash.new do |h, k|
      kx, ky = k
      if k == [0, 0] || k == @target
        h[k] = 0
      elsif ky == 0
        h[k] = kx * 16807
      elsif kx == 0
        h[k] = ky * 48271
      else
        h[k] = erosion_level(kx - 1, ky) * erosion_level(kx, ky - 1)
      end
    end
    @geologic_index[[x, y]]
  end

  def erosion_level(x, y)
    (geologic_index(x, y) + @depth) % 20183
  end

  def type(x, y)
    [:rocky, :wet, :narrow][erosion_level(x, y) % 3]
  end

  RISK_FACTORS = {
    rocky:  0,
    wet:    1,
    narrow: 2
  }
  def risk_level
    tx, ty = @target
    (0..ty).reduce(0) do |ry, y|
      ry + (0..tx).reduce(0) do |rx, x|
        rx + RISK_FACTORS[type(x, y)]
      end
    end
  end

  TOOL_CHOICES = {
    rocky:  [:gear, :torch],
    wet:    [:gear, :neither],
    narrow: [:torch, :neither]
  }
  def fastest_route(start=[0, 0], finish=@target, tool=:torch)
    visited = Set.new

    to_visit = PriorityQueue.new do |cost, pos, tool|
      -1 * cost
    end
    to_visit << [0, start, tool]
    until to_visit.empty?
      cost, pos, tool = to_visit.pop
      next if visited.member?([pos, tool])
      visited << [pos, tool]
      break if pos == @target && tool == :torch

      x, y = pos
      type = type(*pos)

      # switch tool but stay in current position
      TOOL_CHOICES[type].each do |new_tool|
        next if new_tool == tool
        to_visit << [cost + 7, pos, new_tool] unless visited.member?([pos, new_tool])
      end

      # move to adjacent region
      potential_moves = [[1, 0], [0, 1]]
      potential_moves << [0, -1] if y - 1 >= 0
      potential_moves << [-1, 0] if x - 1 >= 0

      potential_moves.each do |dx, dy|
        new_pos = [x + dx, y + dy]
        next if visited.member?(new_pos)
        utype = type(*new_pos)
        # move if it's possible to move with the current tool
        if TOOL_CHOICES[utype].include?(tool) &&
            !visited.member?([new_pos, tool])
          to_visit << [cost + 1, new_pos, tool]
        end
      end
    end
    cost
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip.split("\n")

depth = input[0].slice(7..-1).to_i
target = input[1].slice(8..-1).split(",").map(&:to_i)

analyzer = CaveAnalyzer.new(depth, target)
puts analyzer.risk_level
puts analyzer.fastest_route
