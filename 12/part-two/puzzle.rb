# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Cave
  attr_reader :name, :large, :neighbors

  def initialize(name:)
    @name = name
    @large = name == name.upcase
    @neighbors = []
  end

  def add_neighbor(neighbor:)
    @neighbors << neighbor unless @neighbors.any? { |n| n.name == neighbor.name }
  end

  def to_s
    <<~CAVE
      Name:      #{@name}
      Neighbors: #{@neighbors.map(&:name).join(' ')}
    CAVE
  end
end

class Puzzle
  attr_reader :data, :paths

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    $caves = {}
    @paths = []

    @data.each do |row|
      cave_1, cave_2 = row.split('-')
      $caves[cave_1] = Cave.new(name: cave_1) unless $caves.key? cave_1
      $caves[cave_2] = Cave.new(name: cave_2) unless $caves.key? cave_2

      $caves[cave_1].add_neighbor(neighbor: $caves[cave_2])
      $caves[cave_2].add_neighbor(neighbor: $caves[cave_1])
    end

  end

  def perform
    $caves['start'].neighbors.each do |neighbor|
      navigate(Marshal.load(Marshal.dump($caves)), Marshal.load(Marshal.dump(neighbor)), ['start'])
    end

    self
  end

  def navigate(caves, cave, current_path)
    return if !cave.large && (current_path.include?(cave.name) && current_path.select { _1.downcase == _1 }.tally.values.any?(2) )

    if cave.name == 'end'
      @paths << current_path.push('end')
      return
    end

    cave.neighbors.each do |neighbor|
      next if neighbor.name == 'start'

      navigate(Marshal.load(Marshal.dump(caves)), Marshal.load(Marshal.dump(neighbor)), current_path.clone.push(cave.name))
    end
  end

  def to_s
    <<~OUTPUT
      Paths: #{@paths.count}
    OUTPUT
  end
end

puts Puzzle.new(file: '12/part-one/input.txt').perform
