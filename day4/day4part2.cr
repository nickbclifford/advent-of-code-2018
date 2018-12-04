logs = File.read_lines("input.txt").map do |log|
  {text: log["[YYYY-MM-DD HH:MM] ".size..-1], time: Time.parse_utc(log[1.."YYYY-MM-DD HH:MM".size], "%F %H:%M")}
end.sort_by(&.[:time])

alias Times = {start: Int32, end: Int32}

guard_spans = Hash(UInt32, Set(Times)).new { |hsh, k| hsh[k] = Set(Times).new }

# I know this is unidiomatic but idk how else to rewind a loop
i = 0
while i < logs.size
  log = logs[i]

  guard_id = log[:text].split[1][1..-1].to_u32
  
  loop do
    break unless (i + 1) < logs.size
    falls_asleep = logs[i += 1] 
    if falls_asleep[:text] == "falls asleep"
      wakes_up = logs[i += 1]
      guard_spans[guard_id] << {start: falls_asleep[:time].minute, end: wakes_up[:time].minute}
    else
      i -= 1
      break
    end
  end

  i += 1
end

times_asleep_at_min = guard_spans.each_with_object({} of UInt32 => Array(Int32)) do |(id, times), hash|
  hash[id] = (0..59).map do |min|
    times.count { |t| (t[:start]..t[:end]).includes?(min) }
  end
end

most_asleep_minutes = (0..59).map do |min|
  max = times_asleep_at_min.max_by { |(_, minutes)| minutes[min] }
  {id: max[0], value: max[1][min]}
end

max = most_asleep_minutes.max_by(&.[:value])
puts max, max[:id] * times_asleep_at_min[max[:id]].index(max[:value]).not_nil!
