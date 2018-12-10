require "time"

module AlchemicalReductor
  SUBSTITUTIONS = Regexp.union(('a'..'z').flat_map { |l| [l + l.upcase, l.upcase + l] })

  def perform(polymer)
    cancel_pairs(polymer).length
  end

  def perform_optimal(original_polymer)
    ('a'..'z').reduce(original_polymer) do |min_polymer, unit|
      new_polymer = cancel_pairs(original_polymer.gsub(/#{unit}|#{unit.upcase}/, ""))
      new_polymer.length < min_polymer.length ? new_polymer : min_polymer
    end.length
  end

  def cancel_pairs(polymer)
    polymer
      .chars
      .each_with_object([]) do |unit, stack|
        stack.empty? || (unit.ord - stack[-1].ord).abs != 32 ? stack.push(unit) : stack.pop
      end
      .join
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

puts AlchemicalReductor.perform(input)
puts AlchemicalReductor.perform_optimal(input)
