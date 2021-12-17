# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Map
  attr_reader :x_range, :y_range, :possible_initial_velocities

  def initialize(input)
    @x_range = input.match(/x=(.*),/)[1].split('..').inject { _1.to_i.._2.to_i }
    @y_range = input.match(/y=(.*)/)[1].split('..').inject { _1.to_i.._2.to_i }
    @possible_initial_velocities = []
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

  # Let's bruteforce
  def perform
    (0..@x_range.max).each do |x_vel|
      (@y_range.min..velocity_y_max).each do |y_vel|
        process(x_vel, y_vel)
      end
    end

    self
  end

  def process(x_vel, y_vel)
    current_x = 0
    current_y = 0

    while current_x <= @x_range.max && current_y >= @y_range.min
      current_x += x_vel
      current_y += y_vel

      if @x_range.include?(current_x) && @y_range.include?(current_y)
        @possible_initial_velocities << [x_vel, y_vel]
        break
      end

      x_vel -= 1 if x_vel.positive?
      y_vel -= 1

      break if x_vel.zero? && !@x_range.include?(current_x)
    end
  end
end

class Puzzle
  attr_reader :data, :map

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @map = Map.new(@data[0]).perform
  end

  def perform

    self
  end


  def to_s
    <<~OUTPUT
      Highest Y : #{@map.highest_y}
      Initial velocities : #{@map.possible_initial_velocities.length}
    OUTPUT
  end
end

puts Puzzle.new(file: '17/part-one/input.txt').perform
