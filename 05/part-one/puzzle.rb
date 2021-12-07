# frozen_string_literal: true

require_relative '../../commons/input_reader'
require_relative '../../commons/vector'

class Puzzle
  attr_reader :data, :parsed_data, :matrix

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @parsed_data = @data.map do |row|
      Vector.new(ary: row.split(' -> ').map { |tuple| tuple.split(',') }.flatten)
    end.select { |vector| vector.horizontal? || vector.vertical? }
  end

  def perform
    @matrix = Array.new(@parsed_data.map(&:biggest_y).max + 1) { Array.new(@parsed_data.map(&:biggest_x).max + 1, 0) }

    @parsed_data.each do |vector|
      vector.points.each do |point|
        @matrix[point[1]][point[0]] += 1
      end
    end

    self
  end

  def to_s
    <<~OUTPUT
      More than 2: #{@matrix.flatten.select { |i| i >= 2 }.count}
    OUTPUT
  end
end

puts Puzzle.new(file: '05/part-one/input.txt').perform
