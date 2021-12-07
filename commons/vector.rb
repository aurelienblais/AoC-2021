class Vector
  attr_reader :x1, :y1, :x2, :y2

  def initialize(ary:)
    @x1 = ary[0].to_i
    @y1 = ary[1].to_i
    @x2 = ary[2].to_i
    @y2 = ary[3].to_i
  end

  def horizontal?
    @x1 == @x2
  end

  def vertical?
    @y1 == @y2
  end

  def diagonal?
    (@x1 - @x2).abs == (@y1 - @y2).abs
  end

  def smallest_x
    @x1 > @x2 ? @x2 : @x1
  end

  def biggest_x
    @x1 > @x2 ? @x1 : @x2
  end

  def smallest_y
    @y1 > @y2 ? @y2 : @y1
  end

  def biggest_y
    @y1 > @y2 ? @y1 : @y2
  end

  def points
    points = []
    if diagonal?
      x_mod = @x1 > @x2 ? -1 : 1
      y_mod = @y1 > @y2 ? -1 : 1
      tuple = [@x1, @y1]

      while tuple[0] != @x2
        points << tuple
        tuple = [tuple[0] + x_mod, tuple[1] + y_mod]
      end

      points << tuple
    else
      (smallest_x..biggest_x).each do |x|
        (smallest_y..biggest_y).each do |y|
          points << [x, y]
        end
      end
    end
    points
  end
end
