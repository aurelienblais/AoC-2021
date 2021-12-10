# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :score
  
  PAIRS = {
    '(' => ')',
    '[' => ']',
    '{' => '}',
    '<' => '>'
  }.freeze

  SCORE = {
    ')' => 3,
    ']' => 57,
    '}' => 1_197,
    '>' => 25_137
  }.freeze

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content.map { _1.split('') }
    @score = 0
  end

  def perform
    @data.each do |row|
      stack = []

      row.each do |char|
        if PAIRS.key? char
          stack << char
        elsif char != PAIRS[stack.pop]
          @score += SCORE[char]
          next
        end
      end
    end

    self
  end

  def to_s
    <<~OUTPUT
      Score: #{@score}
    OUTPUT
  end
end

puts Puzzle.new(file: '10/part-one/input.txt').perform
