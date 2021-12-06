# frozen_string_literal: true

require_relative '../../commons/input_reader'
require_relative '../../commons/bingo'

class Puzzle
  attr_reader :data, :grids, :drawn_numbers, :winner_grid, :current_number

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @grids = []
  end

  def perform
    @drawn_numbers = @data.shift(1)[0].split(',').map(&:to_i)

    @data.reject { |row| row == '' }.each_slice(5) do |raw_grid|
      @grids << Bingo.new(raw_grid: raw_grid)
    end

    while @winner_grid.nil?
      @current_number = @drawn_numbers.shift(1)[0]

      @grids.each { |grid| grid.try_mark(number: @current_number) }

      @winner_grid = @grids.find(nil, &:valid?)
    end

    self
  end

  def to_s
    <<~OUTPUT
      Result: #{@winner_grid.result * @current_number}
    OUTPUT
  end
end

puts Puzzle.new(file: '04/part-one/input.txt').perform
