fabric = Array(Array(UInt32)).new(1000) { Array(UInt32).new(1000) { 0_u32 } }

File.read_lines("input.txt").each do |claim|
  if match = claim.match(/^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/)
    pos_x = match[2].to_i
    pos_y = match[3].to_i
    size_x = match[4].to_i
    size_y = match[5].to_i

    size_y.times do |i|
      size_x.times do |j|
        fabric[pos_y + i][pos_x + j] += 1
      end
    end
  end
end

totals =
  fabric.map do |row|
    row.count do |inch|
      inch >= 2
    end
  end

puts totals.sum
