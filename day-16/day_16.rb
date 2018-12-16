module ChronalBytecode
  extend self
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

  def potential_instructions(bytecode, before, after)
    INSTRUCTIONS.keys.select do |k|
      registers = before.dup
      execute(k, bytecode, registers)
      registers == after
    end
  end

  def execute(instruction, bytecode, registers)
    args = bytecode.slice(1..-1)
    INSTRUCTIONS[instruction].call(args, registers)
  end

  def analyze_observations(input, &block)
    input
      .split("\n\n")
      .map { |example| parse_example(example) }
      .map do |bytecode, before, after|
        opcode, *args = bytecode
        [bytecode, potential_instructions(bytecode, before, after)]
      end
      .yield_self { |s| block_given? ? block.call(s) : s }
  end

  def parse_example(example)
    l1, l2, l3 = example.split("\n")
    [parse_bytecode(l2), parse_register_state(l1), parse_register_state(l3)]
  end

  def parse_register_state(line)
    line
      .slice(9..-2)
      .split(", ")
      .map(&:to_i)
  end

  def parse_bytecode(line)
    line.split(" ").map(&:to_i)
  end

  def run_program(observations, program)
    opcode_mapping = analyze_observations(observations) do |obs|
      bytecode_mappings = obs.each_with_object({}) do |(bytecode, potential_opcodes), m|
        m[bytecode.first] ||= potential_opcodes
        m[bytecode.first] &= potential_opcodes
      end

      while bytecode_mappings.values.any? { |p| p.length > 1 }
        single_values = bytecode_mappings.values.select { |v| v.length == 1 }.flatten
        bytecode_mappings.each do |k, v|
          bytecode_mappings[k] = v - single_values if v.length > 1
        end
      end

      Hash[bytecode_mappings.map { |k,v| [k, v.first] }]
    end

    registers = Array.new(4, 0)
    program
      .split("\n")
      .each do |line|
        bytecode = parse_bytecode(line)
        instruction = opcode_mapping[bytecode.first]
        execute(instruction, bytecode, registers)
      end

    registers[0]
  end
end

return unless $PROGRAM_NAME == __FILE__

filename = ARGV.shift || File.expand_path("input.txt", __dir__)
input = File.read(filename).strip

part_1, part_2 = input.split("\n\n\n").map(&:strip)

puts ChronalBytecode.analyze_observations(part_1){ |obs| obs.count { |_, p| p.length >= 3 } }
puts ChronalBytecode.run_program(part_1, part_2)
