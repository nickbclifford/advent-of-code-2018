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

id, asleep_times = guard_spans.max_by do |(_, set)|
  set.map { |time| time[:end] - time[:start] }.sum
end

asleep_minute = (0..59).max_by do |min|
  asleep_times.map { |t| (t[:start]..t[:end]).includes?(min) ? 1 : 0 }.sum
end

puts id, asleep_minute, id * asleep_minute
