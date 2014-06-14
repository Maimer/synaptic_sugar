class Background

  def initialize(window)
    @window = window
    @bg = Gosu::Image.new(@window, 'images/starscape.png')
  end

  def update

  end

  def draw
    @bg.draw(0, 0, 1)
  end
end
