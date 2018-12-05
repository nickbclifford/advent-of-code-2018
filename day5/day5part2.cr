polymer = File.read("input.txt").strip

lengths = ('A'..'Z').map do |remove_char|
  new_polymer = polymer.delete(remove_char).delete(remove_char.downcase)

  i = 0
  while (i + 1) < new_polymer.size
    char = new_polymer[i]

    if (char.uppercase? && new_polymer[i + 1] == char.downcase) || (char.lowercase? && new_polymer[i + 1] == char.upcase)
      new_polymer = new_polymer[0...i] + new_polymer[i + 2..-1]
      i -= 1
    else
      i += 1
    end
  end

  new_polymer.size
end

puts lengths.min
