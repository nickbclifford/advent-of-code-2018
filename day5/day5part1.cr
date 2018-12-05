polymer = File.read("input.txt").strip

i = 0
while (i + 1) < polymer.size
  char = polymer[i]

  if (char.uppercase? && polymer[i + 1] == char.downcase) || (char.lowercase? && polymer[i + 1] == char.upcase)
    polymer = polymer[0...i] + polymer[i + 2..-1]
    i -= 1
  else
    i += 1
  end
end

puts polymer.size
