class Asteroid

  attr_reader :x, :y, :asteroid
  attr_accessor :x_vel, :y_vel, :angle

  def initialize(window, x, y, x_vel, y_vel)
    @window = window
    @x = x
    @y = y
    @y_vel = x_vel
    @x_vel = y_vel
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
    if @window.debug == true
      @window.draw_line(@x, @y, Gosu::Color::GREEN, @x + asteroids[@asteroid].width, @y, Gosu::Color::GREEN, 20)
      @window.draw_line(@x, @y, Gosu::Color::GREEN, @x, @y + asteroids[@asteroid].height, Gosu::Color::GREEN, 20)
      @window.draw_line(@x, @y + asteroids[@asteroid].height, Gosu::Color::GREEN, @x + asteroids[@asteroid].width, @y + asteroids[@asteroid].height, Gosu::Color::GREEN, 20)
      @window.draw_line(@x + asteroids[@asteroid].width, @y, Gosu::Color::GREEN, @x + asteroids[@asteroid].width, @y + asteroids[@asteroid].height, Gosu::Color::GREEN, 20)
    end
  end
end
