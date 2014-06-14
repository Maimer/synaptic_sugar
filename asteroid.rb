class Asteroid

  attr_reader :x, :y

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @y_vel = rand(4) + 1
    @x_vel = rand(4) + 1
    @asteroid = rand(6)
    @angle = 0
    if rand(2) == 1
      @angle_vel = rand(4) + 1
    else
      @angle_vel = -rand(4) - 1
    end
  end

  def update
    @x += @x_vel
    @y += @y_vel
    @angle += @angle_vel
  end

  def draw(asteroids)
    asteroids[@asteroid].draw_rot(@x, @y, 7, @angle)
  end
end
