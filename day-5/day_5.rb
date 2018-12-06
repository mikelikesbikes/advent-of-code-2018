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
    :-@ while polymer.gsub!(SUBSTITUTIONS, "")
    polymer
  end

  extend self
end

return unless $PROGRAM_NAME == __FILE__

input = File.read(File.expand_path("../input.txt", __FILE__)).strip

puts AlchemicalReductor.perform(input)
puts AlchemicalReductor.perform_optimal(input)
