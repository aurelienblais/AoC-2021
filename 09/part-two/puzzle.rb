# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Puzzle
  attr_reader :data, :bassins

  def initialize(file:)
    input_reader = InputReader.new(file: file).read
    @data = input_reader.parsed_content.map { _1.split('').map(&:to_i) }
    @bassins = []
  end

  def perform
    @data.count.times do |row|
      @data[0].count.times do |col|
        next if @data[row][col] == 9

        local_cave = [-1, 1].map do |x|
          val = @data.dig(row + x, col)
          val.nil? ? true : @data[row][col] < val
        end + [-1, 1].map do |y|
          val = @data.dig(row, col + y)
          val.nil? ? true : @data[row][col] < val
        end

        find_bassin(row, col) if local_cave.flatten.all?(true)
      end
    end

    @bassins.sort!.reverse!

    self
  end

  def find_bassin(x, y)
    search_queue = [[x, y]]
    visited_elements = [[x, y]]

    while search_queue.any?
      current_item = search_queue.shift
      current_item_val = @data.dig(current_item[0], current_item[1])

      neighbours = [
        [current_item[0] - 1, current_item[1]],
        [current_item[0] + 1, current_item[1]],
        [current_item[0], current_item[1] - 1],
        [current_item[0], current_item[1] + 1]
      ]

      neighbours.each do |neighbour|
        next if visited_elements.include? neighbour

        neighbour_val = @data.dig(neighbour[0], neighbour[1])
        next if neighbour_val.nil? || neighbour_val > 8
        next if current_item_val > neighbour_val

        visited_elements << neighbour
        search_queue << neighbour
      end

    end
    @bassins << visited_elements.size
  end

  def to_s
    <<~OUTPUT
      Bassins size: #{@bassins[0..2]}
      Size: #{@bassins[0..2].reduce(1, &:*)}
    OUTPUT
  end
end

puts Puzzle.new(file: '09/part-one/input.txt').perform