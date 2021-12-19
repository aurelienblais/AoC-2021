# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Coordinate
  attr_reader :x, :y, :z
  attr_reader :alternate_coordinates

  def initialize(x, y, z)
    @x, @y, @z = x, y, z
    @alternate_coordinates = []
  end

  def generate_all_rotations
    @alternate_coordinates << Coordinate.new(@x, -@y, -@z)
    @alternate_coordinates << Coordinate.new(-@x, @y, -@z)
    @alternate_coordinates << Coordinate.new(-@x, -@y, @z)
    @alternate_coordinates << Coordinate.new(@x, @z, -@y)
    @alternate_coordinates << Coordinate.new(@x, -@z, @y)
    @alternate_coordinates << Coordinate.new(-@x, @z, @y)
    @alternate_coordinates << Coordinate.new(-@x, -@z, -@y)
    @alternate_coordinates << Coordinate.new(@y, @z, @x)
    @alternate_coordinates << Coordinate.new(@y, -@z, -@x)
    @alternate_coordinates << Coordinate.new(-@y, @z, -@x)
    @alternate_coordinates << Coordinate.new(-@y, -@z, @x)
    @alternate_coordinates << Coordinate.new(@y, @x, -@z)
    @alternate_coordinates << Coordinate.new(@y, -@x, @z)
    @alternate_coordinates << Coordinate.new(-@y, @x, @z)
    @alternate_coordinates << Coordinate.new(-@y, -@x, -@z)
    @alternate_coordinates << Coordinate.new(@z, @x, @y)
    @alternate_coordinates << Coordinate.new(@z, -@x, -@y)
    @alternate_coordinates << Coordinate.new(-@z, @x, -@y)
    @alternate_coordinates << Coordinate.new(-@z, -@x, @y)
    @alternate_coordinates << Coordinate.new(@z, @y, -@x)
    @alternate_coordinates << Coordinate.new(@z, -@y, @x)
    @alternate_coordinates << Coordinate.new(-@z, @y, @x)
    @alternate_coordinates << Coordinate.new(-@z, -@y, -@x)
  end

  def to_a
    [[x, y, z].join(",")].concat(@alternate_coordinates.map(&:to_a)).flatten
  end
end

class Scanner
  attr_reader :beacons, :coordinate, :name, :manhattan_distances

  def initialize(name)
    @name = name.gsub('-', '').gsub('scanner', '').strip
    @beacons = []
    @manhattan_distances = []
  end

  def add_beacon(beacon)
    @beacons << beacon
    @beacons.each { @manhattan_distances << beacon.manhattan_distance(_1) }
  end

  def extended_beacons_coordinates
    @beacons.flat_map(&:to_a)
  end
end

class Beacon
  attr_reader :coordinate

  def initialize(x, y, z)
    @coordinate = Coordinate.new(x, y, z)
    @coordinate.generate_all_rotations
  end

  def manhattan_distance(other)
    (other.coordinate.x - @coordinate.x).abs + (other.coordinate.y - @coordinate.y).abs + (other.coordinate.z - @coordinate.z).abs
  end

  def to_a
    @coordinate.to_a
  end
end

class Puzzle
  attr_reader :data, :scanners

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @scanners = []

    current_scanner = nil

    while (row = @data.shift(1)[0])
      if row.include? 'scanner'
        current_scanner = Scanner.new(row)
        @scanners << current_scanner
      elsif row != ''
        x, y, z = row.split(',').map(&:to_i)
        current_scanner.add_beacon(Beacon.new(x, y, z))
      end
    end

  end

  def perform
    overlapping_scanners = []

    @scanners.each do |scanner_1|
      @scanners.each do |scanner_2|
        next if scanner_1 == scanner_2
        if (scanner_1.manhattan_distances.uniq.sort & scanner_2.manhattan_distances.uniq.sort).length >= 12
          overlapping_scanners << [scanner_1, scanner_2].sort { _1.name <=> _2.name }
        end
      end
    end

    p overlapping_scanners.uniq.map { _1.map(&:name) }

    self
  end


  def to_s
    <<~OUTPUT
    OUTPUT
  end
end

puts Puzzle.new(file: '19/part-one/input.txt').perform
