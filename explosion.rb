class Explosion

  attr_reader :start

  def initialize(window, x, y)
    @window = window
    @x = x
    @y = y
    @start = Gosu::milliseconds
  end

  def draw(explosions)
    img = explosions[((Gosu::milliseconds - @start) / 50) % explosions.size]
    img.draw(@x, @y, 8)
    if @window.debug == true
      @window.draw_line(@x, @y, Gosu::Color::GREEN, @x + explosions[0].width, @y, Gosu::Color::GREEN, 20)
      @window.draw_line(@x, @y, Gosu::Color::GREEN, @x, @y + explosions[0].height, Gosu::Color::GREEN, 20)
      @window.draw_line(@x, @y + explosions[0].height, Gosu::Color::GREEN, @x + explosions[0].width, @y + explosions[0].height, Gosu::Color::GREEN, 20)
      @window.draw_line(@x + explosions[0].width, @y, Gosu::Color::GREEN, @x + explosions[0].width, @y + explosions[0].height, Gosu::Color::GREEN, 20)
    end
  end
end
