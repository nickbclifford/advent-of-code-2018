found_freqs = [0_i32]

File.open("input.txt") do |file|
    loop do
        file.each_line do |line|
            new_freq = found_freqs.last + line.to_i
            # puts new_freq
            if found_freqs.includes?(new_freq)
                puts new_freq
                exit
            else
                found_freqs << new_freq
            end
        end
        file.rewind
    end
end