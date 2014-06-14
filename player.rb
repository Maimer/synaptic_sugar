class Player

  def initialize(window)
    @window = window
    @ship = Gosu::Image.new(window, 'images/ship.png')
    @x = (window.width / 2) - (@ship.width / 2)
    @y = (window.height / 2) - (@ship.width / 2)
    @cx = @x + (@ship.width / 2)
    @cy = @y + (@ship.width / 2)
  end

  def update

  end

  def draw
    @ship.draw(@x, @y, 10)
  end
end
