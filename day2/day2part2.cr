box_ids = File.read_lines("input.txt")

box_ids.each_with_index do |id1, index|
  box_ids[index + 1..-1].each do |id2|
    diffs = 0
    common = ""
    id1.chars.each_with_index do |c1, char_idx|
      c2 = id2[char_idx]

      if c1 != c2
        diffs += 1
      else
        common += c1
      end
    end

    puts common if diffs == 1
  end
end
