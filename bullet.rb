class Bullet

  def initialize(window, x, y, x_vel, y_vel)
    @window = window
    @x = x
    @y = y
    @x_vel = x_vel
    @y_vel = y_vel
  end

  def update
    @x += @x_vel
    @y += @y_vel
  end

  def draw

  end
end
