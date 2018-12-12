class Garden
  attr_reader :state, :rules, :offset
  def initialize(initial_state, rules, offset = 0)
    @state = initial_state
    @rules = rules
    @offset = offset
    repad
  end

  def self.from_input(input)
    input = input.split("\n")
    state = input.shift.slice(15..-1)
    input.shift
    rules = Hash[input.map { |line| line.split(" => ") }]
    new(state, rules)
  end

  def live_plants
    @state
      .chars
      .each_with_index
      .select { |c, i| c == "#" }
      .map { |_, i| i - offset }
  end

  def tick(n = 1)
    n.times do |i|
      new_state = "." * @state.length
      (2...@state.length - 2).each do |i|
        new_state[i] = rules[@state.slice(i-2, 5)] || "."
      end
      @state = new_state
      repad
    end

    self
  end

  def sum_after_tick(n)
    i = 0
    sums = [live_plants.sum]
    diffs = []
    while i < n
      i += 1
      tick
      sums << live_plants.sum
      diffs << (sums[-1] - sums[-2])
      break if diffs.length >= 100 && diffs.slice(-100..-1).uniq.length == 1
    end

    i == n ? sums.last : sums.last + ((n - i) * diffs.last)
  end

  private

  def repad
    @state.sub!(/^(\.*)(.*?)(\.*)$/, '.....\2.....')
    @offset = @offset - $1.length + 5
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

puts Garden.from_input(input).sum_after_tick(20)
puts Garden.from_input(input).sum_after_tick(50_000_000_000)
