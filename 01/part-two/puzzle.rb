# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :increasement, :decreasement

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = generate_windows(raw_data: input_reader.parsed_content.map(&:to_i))

    @increasement = 0
    @decreasement = 0
  end

  def generate_windows(raw_data:)
    (1..raw_data.count - 2).map do |i|
      raw_data[i - 1] + raw_data[i] + raw_data[i + 1]
    end
  end

  def perform
    cursor = @data.shift(1).first
    @data.each do |n|
      if n > cursor
        @increasement += 1
      else
        @decreasement += 1
      end
      cursor = n
    end

    self
  end

  def to_s
    <<~OUTPUT
      Increasement: #{@increasement}
      Decreasement: #{@decreasement}
    OUTPUT
  end
end

puts Puzzle.new(file: '01/part-one/input.txt').perform
