box_ids = File.read_lines("input.txt")

twice = 0
thrice = 0

box_ids.each do |id|
  puts id
  is_twice = false
  is_thrice = false
  id.chars.uniq.each do |char|
    case id.count(char)
    when 2
      twice += 1 unless is_twice
      is_twice = true
    when 3
      thrice += 1 unless is_thrice
      is_thrice = true
    end
  end
end

puts twice * thrice
