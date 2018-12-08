struct Coordinate
  getter x : Int32
  getter y : Int32

  def initialize(@x, @y)
  end

  def distance_to(other : Coordinate)
    (x - other.x).abs + (y - other.y).abs
  end
end

input_coords = File.read_lines("input.txt").map do |line|
  arr = line.split(", ")
  Coordinate.new(arr[0].to_i, arr[1].to_i)
end

closest_coords = Hash(Coordinate, Set(Coordinate)).new { |h, k| h[k] = Set(Coordinate).new }

0.upto 399 do |y|
  0.upto 399 do |x|
    coord = Coordinate.new(x, y)
    distances = input_coords.map { |c| {c, coord.distance_to(c)} }
    closest, distance = distances.min_by(&.[1])
    
    closest_coords[closest] << coord unless distances.count { |(_, d)| d == distance } > 1
  end
end

totals = closest_coords.reject do |_, set|
  set.any? { |c| c.x == 0 || c.y == 0 || c.x == 399 || c.y == 399 }
end.map do |(coord, set)|
  set.size
end

puts totals.max
