# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Map
  attr_reader :x_range, :y_range

  def initialize(input)
    @x_range = input.match(/x=(.*),/)[1].split('..').inject { _1.to_i.._2.to_i }
    @y_range = input.match(/y=(.*)/)[1].split('..').inject { _1.to_i.._2.to_i }
  end

  # https://www.cliffsnotes.com/study-guides/trigonometry/graphs-of-trigonometric-functions/graphs-sine-and-cosine
  # We're looking for the local maximum, which is based on the local minimum
  def velocity_y_max
    y_range.min.abs - 1
  end

  # Maximum Y is obtained when velocity is 0
  def highest_y
    velocity_y_max * (velocity_y_max + 1) / 2
  end
end

class Puzzle
  attr_reader :data, :map

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @map = Map.new(@data[0])
  end

  def perform

    self
  end


  def to_s
    <<~OUTPUT
      Highest Y : #{@map.highest_y}
    OUTPUT
  end
end

puts Puzzle.new(file: '17/part-one/input.txt').perform
