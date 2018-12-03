freq = 0

all_freqs = File.read_lines("input.txt").map(&.to_i)

all_freqs.each do |i|
  freq += i
end

puts freq
