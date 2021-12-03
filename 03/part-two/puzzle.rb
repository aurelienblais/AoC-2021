# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :computed_data, :oxygen, :co2

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @computed_data = {}
  end

  def perform
    @data.each do |row|
      row.split('').each_with_index do |item, idx|
        @computed_data[idx] ||= { '0' => 0, '1' => 0 }
        @computed_data[idx][item] += 1
      end
    end

    self
  end

  def to_s
    <<~OUTPUT
      Oxygen: #{@oxygen}
      CO2: #{@co2}
      Life Support Rating: #{@oxygen * @co2}
    OUTPUT
  end
end

puts Puzzle.new(file: '03/part-one/input.txt').perform
