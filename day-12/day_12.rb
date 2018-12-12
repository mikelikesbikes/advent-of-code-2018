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
      puts i if i % 1_000_000 == 0

      new_state = "." * @state.length
      (2...@state.length - 2).each do |i|
        new_state[i] = rules[@state.slice(i-2, 5)] || "."
      end
      @state = new_state
      repad
    end

    self
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

puts Garden.from_input(input).tick(20).live_plants.sum
puts Garden.from_input(input).tick(50_000_000_000).live_plants.sum
