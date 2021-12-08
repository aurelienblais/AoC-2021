# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :computed_data

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content

  end

  def perform
    @computed_data = @data.map do |row|
      row.split(' | ')[1].split(' ').select { |elem| elem.size == 2 || elem.size == 4 || elem.size == 3 || elem.size == 7 }
    end

    self
  end

  def to_s
    <<~OUTPUT
      1, 4, 7 or 8 : #{@computed_data.flatten.count}
    OUTPUT
  end
end

puts Puzzle.new(file: '08/part-one/input.txt').perform
