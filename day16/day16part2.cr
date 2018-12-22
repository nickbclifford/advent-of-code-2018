alias Registers = StaticArray(UInt32, 4)

macro def_opcode
  ->(a : UInt32, b : UInt32, c : UInt32, registers : Registers) {
    registers[c] = {{ yield }}
    registers
  }
end

macro to_bit(input)
  {{ input }} ? 1_u32 : 0_u32
end

OPCODES = {
  :addr => def_opcode { registers[a] + registers[b] },
  :addi => def_opcode { registers[a] + b },
  :mulr => def_opcode { registers[a] * registers[b] },
  :muli => def_opcode { registers[a] * b },
  :banr => def_opcode { registers[a] & registers[b] },
  :bani => def_opcode { registers[a] & b },
  :borr => def_opcode { registers[a] | registers[b] },
  :bori => def_opcode { registers[a] | b },
  :setr => def_opcode { registers[a] },
  :seti => def_opcode { a },
  :gtir => def_opcode { to_bit(a > registers[b]) },
  :gtri => def_opcode { to_bit(registers[a] > b) },
  :gtrr => def_opcode { to_bit(registers[a] > registers[b]) },
  :eqir => def_opcode { to_bit(a == registers[b]) },
  :eqri => def_opcode { to_bit(registers[a] == b) },
  :eqrr => def_opcode { to_bit(registers[a] == registers[b]) }
}

input = File.read("input.txt")

separator_index = input.index("\n\n\n").not_nil!

samples = input[0..separator_index].lines.reject(&.empty?).in_groups_of(3).map do |slice|
  # Before: [X, X, X, X]
  before = Registers[slice[0].not_nil![9].to_u32, slice[0].not_nil![12].to_u32, slice[0].not_nil![15].to_u32, slice[0].not_nil![18].to_u32]

  instructions = slice[1].not_nil!.split.map(&.to_u32)
  instruction = {instructions[0], instructions[1], instructions[2], instructions[3]}

  # After:  [X, X, X, X]
  after = Registers[slice[2].not_nil![9].to_u32, slice[2].not_nil![12].to_u32, slice[2].not_nil![15].to_u32, slice[2].not_nil![18].to_u32]

  {before: before, after: after, instruction: instruction}
end

opcode_candidates = Hash(UInt32, Set(Symbol)).new { |h, k| h[k] = Set(Symbol).new }

samples.each do |sample|
  OPCODES.each do |(k, proc)|
    if proc.call(sample[:instruction][1], sample[:instruction][2], sample[:instruction][3], sample[:before]) == sample[:after]
      opcode_candidates[sample[:instruction][0]] << k
    end
  end
end

opcode_lookup = uninitialized Symbol[16]

until opcode_candidates.empty?
  instruction, candidates = opcode_candidates.find { |(_, s)| s.size == 1 }.not_nil!
  opcode = candidates.first

  opcode_candidates.delete(instruction)

  opcode_candidates.select { |_, s| s.includes?(opcode) }.each { |(_, s)| s.delete(opcode) }

  opcode_lookup[instruction] = opcode
end

registers = Registers.new(0)

input[separator_index + 4..-1].each_line do |instruction|
  opcode, a, b, c = instruction.split.map(&.to_u32)

  registers = OPCODES[opcode_lookup[opcode]].call(a, b, c, registers)
end

puts registers[0]
