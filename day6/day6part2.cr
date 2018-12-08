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

total_distances = [] of Int32

0.upto 399 do |y|
  0.upto 399 do |x|
    coord = Coordinate.new(x, y)
    distances = input_coords.map { |c| coord.distance_to(c) }

    total_distances << distances.sum
  end
end

puts total_distances.count { |d| d < 10000 }
