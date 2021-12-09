# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :risk_level

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content.map { _1.split('').map(&:to_i) }
    @risk_level = 0
  end

  def perform
    @data.count.times do |row|
      @data[0].count.times do |col|
        next if @data[row][col] == 9

        local_cave = [-1, 1].map do |x|
          val = @data.dig(row + x, col)
          val.nil? ? true : @data[row][col] < val
        end + [-1, 1].map do |y|
          val = @data.dig(row, col + y)
          val.nil? ? true : @data[row][col] < val
        end

        @risk_level += 1 + @data[row][col] if local_cave.flatten.all?(true)
      end
    end

    self
  end

  def to_s
    <<~OUTPUT
      Risk level: #{@risk_level}
    OUTPUT
  end
end

puts Puzzle.new(file: '09/part-one/input.txt').perform
