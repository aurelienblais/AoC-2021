# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Octopus
  attr_reader :level, :x, :y, :has_flashed

  def initialize(level:, x:, y:)
    @level = level.to_i
    @x = x
    @y = y
    @has_flashed = false
  end

  def neighbours
    @neighbours ||= (-1..1).map do |x_mod|
      (-1..1).map do |y_mod|
        $octopuses.find { |o| o.x == @x + x_mod && o.y == @y + y_mod }
      end
    end.flatten.reject { _1 == self }.compact
  end

  def inc_level
    return if @has_flashed

    @level += 1
  end

  def flash
    return if @level <= 9

    neighbours.each(&:inc_level)
    @level = 0
    @has_flashed = true
  end

  def reset_flash
    @has_flashed = false
  end
end

class Puzzle
  attr_reader :data, :step

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    $octopuses = @data.each_with_index.map { |row, x| row.split('').each_with_index.map { |val, y| Octopus.new(level: val, x: x, y: y) } }.flatten
  end

  def perform
    i = 0
    while step.nil? do
      i += 1
      $octopuses.each(&:reset_flash)
      $octopuses.each(&:inc_level)

      while (should_flash = $octopuses.select { _1.level > 9 && !_1.has_flashed }) && should_flash.any?
        should_flash.each(&:flash)
      end

      @step = i if $octopuses.select(&:has_flashed).count == $octopuses.count
    end

    self
  end

  def to_s
    <<~OUTPUT
      Step : #{@step}
    OUTPUT
  end
end

puts Puzzle.new(file: '11/part-one/input.txt').perform
