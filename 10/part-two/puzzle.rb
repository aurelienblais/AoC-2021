# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :filtered_data, :scores

  PAIRS = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
  }.freeze

  SCORE = {
    ')' => 1,
    ']' => 2,
    '}' => 3,
    '>' => 4
  }.freeze

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content.map { _1.split('') }
    @filtered_data = filter_data
  end

  def perform
    @scores = @filtered_data.map do |row|
      stack = []
      row.each { |char| PAIRS.key?(char) ? stack << char : stack.pop }
      stack.map { PAIRS[_1] }.reverse.reduce(0) { _1 * 5 + SCORE[_2] }
    end

    self
  end

  def filter_data
    @data.select do |row|
      stack = []

      row.map do |char|
        if PAIRS.key? char
          stack << char
          true
        elsif char != PAIRS[stack.pop]
          false
        end
      end.compact.all? true
    end
  end

  def to_s
    <<~OUTPUT
      Data size: #{@data.size}
      Filtered data size: #{@filtered_data.size}
      Score: #{@scores.sort[@scores.length / 2]}
    OUTPUT
  end
end

puts Puzzle.new(file: '10/part-one/input.txt').perform
