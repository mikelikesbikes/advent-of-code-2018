class Device
  attr_reader :registers, :ip

  def initialize(instructions, instruction_pointer = 0)
    @instructions = instructions
    @ip_register = instruction_pointer
    @taps = []
    self.reset
  end

  def dump
    [@ip, @registers]
  end

  def reset
    @ip = 0
    @registers = Array.new(6, 0)
    @halt = false
    @taps.clear
  end

  def run
    while (0...@instructions.length).include?(@ip)
      step
      break if @halt
    end
  end

  def step
    op, *args = current_instruction
    @registers[@ip_register] = @ip
    INSTRUCTIONS[op].call(args, @registers)
    call_taps
    return if @halt
    @ip = @registers[@ip_register] + 1
  end

  def current_instruction
    @instructions[@ip]
  end

  def add_tap(&block)
    @taps << block
  end

  def halt!
    @halt = true
  end

  private

  def call_taps
    @taps.each { |tap| tap.call(self) }
  end

  INSTRUCTIONS = {
    addr: -> ((a, b, c), r) { r[c] = r[a] + r[b] },
    addi: -> ((a, b, c), r) { r[c] = r[a] + b },
    mulr: -> ((a, b, c), r) { r[c] = r[a] * r[b] },
    muli: -> ((a, b, c), r) { r[c] = r[a] * b },
    banr: -> ((a, b, c), r) { r[c] = r[a] & r[b] },
    bani: -> ((a, b, c), r) { r[c] = r[a] & b },
    borr: -> ((a, b, c), r) { r[c] = r[a] | r[b] },
    bori: -> ((a, b, c), r) { r[c] = r[a] | b },
    setr: -> ((a, b, c), r) { r[c] = r[a] },
    seti: -> ((a, b, c), r) { r[c] = a },
    gtir: -> ((a, b, c), r) { r[c] = a > r[b] ? 1 : 0 },
    gtri: -> ((a, b, c), r) { r[c] = r[a] > b ? 1 : 0 },
    gtrr: -> ((a, b, c), r) { r[c] = r[a] > r[b] ? 1 : 0 },
    eqir: -> ((a, b, c), r) { r[c] = a == r[b] ? 1 : 0 },
    eqri: -> ((a, b, c), r) { r[c] = r[a] == b ? 1 : 0 },
    eqrr: -> ((a, b, c), r) { r[c] = r[a] == r[b] ? 1 : 0 }
  }

  def self.load_program(input)
    ip_line, *instruction_lines = input.split("\n")
    instruction_pointer = parse_instruction_pointer(ip_line)
    instructions = instruction_lines.map { |line| parse_instruction(line) }

    new(instructions, instruction_pointer)
  end

  def self.parse_instruction_pointer(str)
    str.split(" ").last.to_i
  end

  def self.parse_instruction(str)
    opcode, *args = str.split(" ")
    [opcode.to_sym, *args.map(&:to_i)]
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

device = Device.load_program(input)
device.add_tap do |d|
  # instruction 24 sets the target register with the value we're working with
  # in part 1 find the value in that register, then run the ruby
  # implementation of the provided algorithm (the sum of all factors of n
  # from 1..n). This tap saves ~4s on the runtime of part 1, so it's not
  # critical.
  if d.ip == 24
    r = d.current_instruction.last
    n = d.registers[r]
    d.registers[0] = (1..n).select { |i| n % i == 0 }.sum
    d.halt!
  end
end
device.run
puts device.registers[0]

device.reset
device.registers[0] = 1
device.add_tap do |d|
  # instruction 33 sets the target register with the value we're working with
  # in part 2 find the value in that register, then run the ruby
  # implementation of the provided algorithm (the sum of all factors of n
  # from 1..n)
  if d.ip == 33
    r = d.current_instruction.last
    n = d.registers[r]
    d.registers[0] = (1..n).select { |i| n % i == 0 }.sum
    d.halt!
  end
end

device.run
puts device.registers[0]
