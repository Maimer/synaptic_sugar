class Bullet

  attr_reader :x, :y

  def initialize(window, x, y, x_vel, y_vel, angle)
    @window = window
    @x = x
    @y = y
    @cx = 0
    @cy = 0
    @x_vel = x_vel
    @y_vel = y_vel
    @angle = angle
  end

  def update
    @x += @x_vel
    @y += @y_vel
  end

  def draw(bullets)
    img = bullets[(Gosu::milliseconds / 50) % (bullets.size)]
    # img2 = bullets[(Gosu::milliseconds / 50) % (bullets.size - 2)]
    img.draw_rot(@x, @y, 9, @angle)
    # img2.draw_rot(@x, @y, 8, @angle)
  end
end
