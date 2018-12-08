requirements = File.read_lines("input.txt")

dependencies = Hash(Char, Set(Char)).new { |h, k| h[k] = Set(Char).new }

requirements.each do |req|
  # Step ? must be finished before step ? can begin.
  dependency = req[5]
  target = req[36]

  dependencies[target] << dependency
end

puts dependencies

next_new_step : Char

# New step is the only dependency that is not also a target
macro find_new_step
  all_deps = dependencies.values.reduce(Set(Char).new) { |m, s| m.concat(s) }
  all_targets = dependencies.keys.to_set

  next_new_step = (all_deps - all_targets).first
  puts "next new step: #{next_new_step}"
end

find_new_step

order = [next_new_step]

until dependencies.all? { |(_, d)| d.empty? }
  dependencies.each { |(_, d)| d.delete(order.last) }

  next_targets = dependencies.select { |c, d| d.empty? }.map(&.[0]).to_a
  puts next_targets
  if next_targets.empty? || !order.includes?(next_new_step)
    find_new_step
    next_targets << next_new_step
  end
  next_targets.sort!

  puts next_targets

  target = next_targets.first
  order << target
  dependencies.delete(target)

  puts dependencies, "\n"
end

puts order.join
