alias Registers = StaticArray(UInt32, 6)

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
  "addr" => def_opcode { registers[a] + registers[b] },
  "addi" => def_opcode { registers[a] + b },
  "mulr" => def_opcode { registers[a] * registers[b] },
  "muli" => def_opcode { registers[a] * b },
  "banr" => def_opcode { registers[a] & registers[b] },
  "bani" => def_opcode { registers[a] & b },
  "borr" => def_opcode { registers[a] | registers[b] },
  "bori" => def_opcode { registers[a] | b },
  "setr" => def_opcode { registers[a] },
  "seti" => def_opcode { a },
  "gtir" => def_opcode { to_bit(a > registers[b]) },
  "gtri" => def_opcode { to_bit(registers[a] > b) },
  "gtrr" => def_opcode { to_bit(registers[a] > registers[b]) },
  "eqir" => def_opcode { to_bit(a == registers[b]) },
  "eqri" => def_opcode { to_bit(registers[a] == b) },
  "eqrr" => def_opcode { to_bit(registers[a] == registers[b]) }
}

input = File.read_lines("input.txt")

# #ip X
pointer = input[0][4].to_u32

instructions = input[1..-1].map do |instruction|
  opcode, reg_a, reg_b, reg_c = instruction.split
  {OPCODES[opcode], reg_a.to_u32, reg_b.to_u32, reg_c.to_u32}
end

registers = Registers.new(0)
until registers[pointer] > instructions.size
  instruction = instructions[registers[pointer]]
  registers = instruction[0].call(instruction[1], instruction[2], instruction[3], registers)
  registers[pointer] += 1
end

puts registers[0]
