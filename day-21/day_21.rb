class Device
  attr_reader :registers, :ip, :ic

  def initialize(instructions, instruction_pointer = 0)
    @instructions = instructions
    @ip_register = instruction_pointer
    self.reset
  end

  def dump
    [@ip, @registers]
  end

  def reset
    @ip = 0
    @ic = 0
    @registers = Array.new(6, 0)
    @halt = false
    @taps = []
  end

  def set_register(i, v)
    @registers[i] = v
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
    call_taps
    INSTRUCTIONS[op].call(args, @registers)
    @ic += 1
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
    addr: -> ((a, b, c), r) { r[c] = to_signed(r[a] + r[b]) },
    addi: -> ((a, b, c), r) { r[c] = to_signed(r[a] + b) },
    mulr: -> ((a, b, c), r) { r[c] = to_signed(r[a] * r[b]) },
    muli: -> ((a, b, c), r) { r[c] = to_signed(r[a] * b) },
    banr: -> ((a, b, c), r) { r[c] = to_signed(r[a] & r[b]) },
    bani: -> ((a, b, c), r) { r[c] = to_signed(r[a] & b) },
    borr: -> ((a, b, c), r) { r[c] = to_signed(r[a] | r[b]) },
    bori: -> ((a, b, c), r) { r[c] = to_signed(r[a] | b) },
    setr: -> ((a, b, c), r) { r[c] = to_signed(r[a]) },
    seti: -> ((a, b, c), r) { r[c] = to_signed(a) },
    gtir: -> ((a, b, c), r) { r[c] = a > r[b] ? 1 : 0 },
    gtri: -> ((a, b, c), r) { r[c] = r[a] > b ? 1 : 0 },
    gtrr: -> ((a, b, c), r) { r[c] = r[a] > r[b] ? 1 : 0 },
    eqir: -> ((a, b, c), r) { r[c] = a == r[b] ? 1 : 0 },
    eqri: -> ((a, b, c), r) { r[c] = r[a] == b ? 1 : 0 },
    eqrr: -> ((a, b, c), r) { r[c] = r[a] == r[b] ? 1 : 0 }
  }

  def self.to_signed(n)
    length = 32
    mid = 2**(length-1)
    max_unsigned = 2**length

    n = n & (max_unsigned - 1)
    (n>=mid) ? n - max_unsigned : n
  end

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

# device = Device.load_program(input)
# device.set_register(0, 6619857)
# device.add_tap do |d|
#   if d.ip == 28
#     p d.ip, d.ic, d.current_instruction, d.dump
#   end
# end
# device.run
# p device.dump

#device = Device.load_program(input)
#device.set_register(0, 6619857)
# device.add_tap { |d| p d.ic if d.ic % 1_000 == 0 }
#device.add_tap { |d| p d.ip, d.ic, d.current_instruction, d.dump if d.ip == 8 }
#device.add_tap { |d| p d.ip, d.ic, d.current_instruction, d.dump if d.current_instruction.last == 5 }
#device.add_tap do |d|
#  if d.ip == 28
#  end
#end
# device.add_tap { |d| gets if d.ip == 28 }
#device.run

#a = 6619857
#b = c = d = e = f = 0
#f = 123
#begin
#  f = f & 456
#  f = f == 72 ? 1 : 0
#end until f == 1
#
#f = 0
#d = f | 65536
#f = 9010242
#
#begin
#  b = d & 255
#  f = f + b
#  p [a, b, c, d, e, f]
#  f = Device.to_signed(f & 16777215)
#  f = Device.to_signed(f * 65899)
#  f = Device.to_signed(f & 16777215)
#  p [a, b, c, d, e, f]
#  b = 256 > d ? 1 : 0
#  if b == 0
#    b = 0
#    loop do
#      e = b + 1
#      e = e * 256
#      e = e > d ? 1 : 0
#      if e == 0
#        b = b + 1
#      else
#        break
#      end
#    end
#    d = b
#  else
#    b = f == a ? 1 : 0
#  end
#end until b == 1
#p [a, b, c, d, e, f]
#puts "woo"

require 'set'
seen = Set.new

def f a;
    a |= 0x10000
    b = 9010242
    b += a&0xff;       b &= 0xffffff
    b *= 65899;        b &= 0xffffff
    b += (a>>8)&0xff;  b &= 0xffffff
    b *= 65899;        b &= 0xffffff
    b += (a>>16)&0xff; b &= 0xffffff
    b *= 65899;        b &= 0xffffff
    b
end

n = f 0
loop {
    n2 = f n
    break if seen.include? n2
    seen.add n
    n = n2
}
puts n
