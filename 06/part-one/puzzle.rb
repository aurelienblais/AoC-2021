# frozen_string_literal: true

require_relative '../../commons/input_reader'
require_relative '../../commons/vector'

class Puzzle
  attr_reader :data, :fish

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @fish = @data[0].split(',').map(&:to_i)
  end

  def perform

    80.times do
      new_fish = 0
      @fish = @fish.map do |fish|
        if fish.zero?
          new_fish += 1
          6
        else
          fish - 1
        end
      end

      new_fish.times.each { |_| @fish << 8 }
    end

    self
  end

  def to_s
    <<~OUTPUT
      Fish count : #{@fish.count}
    OUTPUT
  end
end

puts Puzzle.new(file: '06/part-one/input.txt').perform
