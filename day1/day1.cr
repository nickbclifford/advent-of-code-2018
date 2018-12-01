freq = 0
found_freqs = Set(Int32).new

all_freqs = File.read_lines("input.txt").map(&.to_i)

all_freqs.cycle do |input_freq|
    new_freq = freq + input_freq
    
    if found_freqs.includes?(new_freq)
        puts new_freq
        exit
    else
        freq = new_freq
        found_freqs << new_freq
    end
end