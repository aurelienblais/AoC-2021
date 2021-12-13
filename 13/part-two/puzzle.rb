# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :matrix, :points, :instructions

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    idx = @data.index('')
    @points = @data[..idx - 1].map { _1.split(',').map(&:to_i) }
    @instructions = @data[idx + 1..].map { _1.gsub('fold along ', '').split('=') }.map { [_1, _2.to_i] }
    @matrix = Array.new(@points.map { _1[1] }.max + 1) { Array.new(@points.map { _1[0] }.max + 1, nil) }
  end

  def perform
    @points.each do |x, y|
      @matrix[y][x] = true
    end

    @instructions.each do |axis, idx|
      matrix = []
      if axis == 'x'
        @matrix.each do |row|
          local_row = []
          idx.times do |id|
            local_row[idx - id] = (row[idx - id] || row[idx + id])
          end

          matrix << local_row
        end
      else
        idx.times do |row|
          matrix << @matrix[row].each_with_index.map { _1 || @matrix[@matrix.length - 1 - row][_2] }
        end
      end
      @matrix = matrix
    end

    @matrix.each do |row|
      puts row.map { _1 ? '#' : ' ' }.join(' ')
    end

    self
  end

  def to_s
    <<~OUTPUT
      Initial size : #{@points.map { _1[0] }.max + 1} x #{@points.map { _1[1] }.max + 1}
      Size : #{@matrix[0].count} x #{@matrix.count}
      Points : #{@matrix.flatten.select{ _1 }.count}
    OUTPUT
  end
end

puts Puzzle.new(file: '13/part-one/input.txt').perform
