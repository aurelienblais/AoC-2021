# frozen_string_literal: true

require_relative '../../commons/input_reader'

class Node
  attr_reader :value, :x, :y

  def initialize(value, x, y)
    @value = value > 9 ? value - 9 : value
    @x = x
    @y = y
  end

  def coordinates
    [x, y]
  end
end

class Graph
  attr_reader :nodes, :path_length, :visited

  def initialize
    @nodes = []
    @costs = {}
    @visited = []
  end

  def add_node(value, x, y, x_data, y_data)
    5.times do |x_mod|
      5.times do |y_mod|
        @nodes << Node.new((value + x_mod + y_mod), x + x_mod * x_data, y + y_mod * y_data)
      end
    end
  end

  def find_node(x, y)
    @nodes.find(nil) { _1.x == x && _1.y == y }
  end

  def neighbours(x, y)
    [[x - 1, y], [x + 1, y], [x, y - 1], [x, y + 1]].map { find_node(_1[0], _1[1]) }.compact
  end

  def dijkstra(source_node, target_node)
    queue = [[0, source_node]]

    until queue.empty?
      cost, node = queue.shift
      return cost if node == target_node
      next if @visited.include? node

      @visited << node

      p @visited.length

      neighbours(node.x, node.y).each do |neighbour|
        current_cost = cost + neighbour.value
        neighbour_min_cost = @costs[neighbour] || Float::INFINITY
        next unless current_cost < neighbour_min_cost

        @costs[neighbour] = current_cost
        queue << [current_cost, neighbour]
        queue.sort_by! { _1[0] }
      end
    end

    Float::INFINITY
  end
end

class Puzzle
  attr_reader :data, :graph, :result

  def initialize(file:)
    input_reader = InputReader.new(file: file).read

    @data = input_reader.parsed_content
    @graph = Graph.new

    @data.each_with_index do |row, y|
      row.split('').each_with_index do |value, x|
        @graph.add_node value.to_i, x, y, @data[0].length, @data.length
      end
    end
  end

  def perform
    @result = @graph.dijkstra(@graph.find_node(0, 0), @graph.find_node(5 * @data[0].length - 1, 5 * @data.length - 1))

    self
  end


  def to_s
    <<~OUTPUT
      Result: #{@result}
    OUTPUT
  end
end

puts Puzzle.new(file: '15/part-one/input.txt').perform
