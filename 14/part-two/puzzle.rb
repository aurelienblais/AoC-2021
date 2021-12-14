# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :template, :pair_insertion, :result

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content
    @template = @data[0].split('').each_cons(2).map { _1.join }.tally
    @pair_insertion = @data[2..].map { _1.split(' -> ') }.map { |k, v| { k => ["#{k.split('')[0]}#{v}", "#{v}#{k.split('')[1]}"] } }.reduce(&:merge)
    @result = {}
  end

  def perform
    last_letter = @data[0].split('').last
    40.times do |n|
      @template.clone.map do |k, v|
        @pair_insertion[k].each do |pair|
          @template[pair] ||= 0
          @template[pair] += v
        end
        @template[k] -= v
      end
    end

    @template.flat_map { |k, v| { k.split('')[0] => v } }.each do |kv|
      k, v = kv.to_a[0]
      @result[k] ||= 0
      @result[k] += v
    end

    @result[last_letter] ||= 0
    @result[last_letter] += 1

    self
  end

  def to_s
    <<~OUTPUT
      Sum: #{@result.values.max - @result.values.min}
    OUTPUT
  end
end

puts Puzzle.new(file: '14/part-one/input.txt').perform
