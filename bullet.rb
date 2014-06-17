class Bullet

  attr_reader :x, :y

  def initialize(window, x, y, x_vel, y_vel, angle)
    @window = window
    @x = x
    @y = y
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
    img.draw_rot(@x, @y, 9, @angle)
    if @window.debug == true
      @window.draw_line(@x, @y, Gosu::Color::GREEN, @x + bullets[0].width, @y, Gosu::Color::GREEN, 20)
      @window.draw_line(@x, @y, Gosu::Color::GREEN, @x, @y + bullets[0].height, Gosu::Color::GREEN, 20)
      @window.draw_line(@x, @y + bullets[0].height, Gosu::Color::GREEN, @x + bullets[0].width, @y + bullets[0].height, Gosu::Color::GREEN, 20)
      @window.draw_line(@x + bullets[0].width, @y, Gosu::Color::GREEN, @x + bullets[0].width, @y + bullets[0].height, Gosu::Color::GREEN, 20)
    end
  end
end
