polymer = File.read("input.txt")

i = 0
while i < polymer.size
  char = polymer[i]

  if (char.uppercase? && polymer[i + 1] == char.downcase) || (char.lowercase? && polymer[i + 1] == char.upcase)
    puts "#{polymer[i - 3...i]}[#{polymer[i..i + 1]}]#{polymer[i + 2..i + 5]}"
    puts "#{polymer[i - 3...i]}[]#{polymer[i + 2..i + 5]}\n"
    polymer = polymer[0...i] + polymer[i + 2..-1]
    i -= 1
  else
    i += 1
  end
end

puts polymer, polymer.size
