class Bingo
  attr_reader :grid

  def initialize(raw_grid:)
    @grid = []

    raw_grid.each do |line|
      @grid << line.split(' ').map { |i| BingoNumber.new(number: i) }
    end
  end

  def try_mark(number:)
    @grid.flatten.each { |n| n.try_mark(number: number) }
  end

  def valid?
    winner = false
    # Check rows
    @grid.each do |row|
      winner = true if row.all?(&:marked)
    end

    # Check columns
    @grid.transpose.each do |col|
      winner = true if col.all?(&:marked)
    end

    # Check diagonals (the naive way)
    winner = true if (0..4).map { |i| @grid[i][i].marked }.reject { |v| v == false }.count == 5
    winner = true if (0..4).map { |i| @grid[4 - i][i].marked }.reject { |v| v == false }.count == 5

    winner
  end

  def result
    @grid.flatten.find_all { |number| !number.marked }.sum(&:number)
  end
end

class BingoNumber
  attr_reader :number, :marked

  def initialize(number:)
    @number = number.to_i
    @marked = false
  end

  def try_mark(number:)
    @marked = true if number == @number
  end
end