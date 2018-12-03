alias Claims = Set(UInt32)

fabric = Array(Array(Claims)).new(1000) { Array(Claims).new(1000) { Claims.new } }

claims = File.read_lines("input.txt")

claim_maps = claims.each_with_object(Hash(UInt32, Set({x: UInt32, y: UInt32})).new) do |claim, map|
  if match = claim.match(/^#(\d+) @ (\d+),(\d+): (\d+)x(\d+)$/)
    claim_id = match[1].to_u32
    pos_x = match[2].to_u32
    pos_y = match[3].to_u32
    size_x = match[4].to_u32
    size_y = match[5].to_u32

    size_y.times do |i|
      size_x.times do |j|
        fabric[pos_y + i][pos_x + j] << claim_id

        if map[claim_id]?
          map[claim_id] << {x: pos_x + j, y: pos_y + i}
        else 
          map[claim_id] = Set{ {x: pos_x + j, y: pos_y + i} }
        end
      end
    end
  end
end

1.upto claims.size do |i|
  if claim_maps[i].all? { |coord| fabric[coord[:y]][coord[:x]].size == 1 }
    puts i
    exit
  end
end
