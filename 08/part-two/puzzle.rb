# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :sum

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @sum = 0
  end

  def perform
    @data.map do |row|
      mappings = {}
      patterns, outputs = row.split(' | ').map { |part| part.split(' ').map { |elem| elem.split('').sort } }

      mappings[1] = patterns.select { _1.count == 2 }.first
      mappings[4] = patterns.select { _1.count == 4 }.first
      mappings[7] = patterns.select { _1.count == 3 }.first
      mappings[8] = patterns.select { _1.count == 7 }.first

      mappings[6] = patterns.select { |pattern| pattern.count == 6 && !mappings[7].all? { |char| pattern.include?(char) } && !mappings.key?(pattern) }.first

      mappings[:c] = mappings[1].select { !mappings[6].include? _1 }[0]
      mappings[:f] = mappings[1].reject { _1 == mappings[:c] }[0]

      mappings[3] = patterns.select { _1.count == 5 && _1.include?(mappings[:c]) && _1.include?(mappings[:f]) && !mappings.value?(_1) }.first
      mappings[2] = patterns.select { _1.count == 5 && _1.include?(mappings[:c]) && !_1.include?(mappings[:f]) && !mappings.value?(_1) }.first
      mappings[5] = patterns.select { _1.count == 5 && !_1.include?(mappings[:c]) && _1.include?(mappings[:f]) && !mappings.value?(_1) }.first

      mappings[:e] = mappings[6].select { !mappings[5].include? _1 }[0]

      mappings[0] = patterns.select { _1.count == 6 && _1.include?(mappings[:e]) && !mappings.value?(_1) }.first
      mappings[9] = patterns.select { !mappings.value? _1 }.first

      codex = mappings.invert

      @sum += outputs.map { codex[_1] }.join.to_i
    end

    self
  end

  def to_s
    <<~OUTPUT
      Sum : #{@sum}
    OUTPUT
  end
end

puts Puzzle.new(file: '08/part-one/input.txt').perform
