# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :template, :pair_insertion

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @template = @data[0].split('')
    @pair_insertion = Hash[@data[2..].map { _1.split(' -> ') }]
  end

  def perform
    10.times do
      local_template = @template.clone
      (@template.count - 1).times do |i|
        pair = @template[i..i + 1].join
        new_element = @pair_insertion[pair]

        local_template.insert 2 * i + 1, new_element
      end
      @template = local_template
    end

    self
  end

  def to_s
    <<~OUTPUT
      Sum: #{@template.tally.values.max - @template.tally.values.min}
    OUTPUT
  end
end

puts Puzzle.new(file: '14/part-one/input.txt').perform
