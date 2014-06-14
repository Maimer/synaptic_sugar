require 'gosu'

require_relative 'player'
require_relative 'background'

SCREEN_WIDTH = 1440
SCREEN_HEIGHT = 1024

class Main <Gosu::Window

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Synaptic Sugar"

    @background = Background.new(self)
    @player = Player.new(self)
  end

  def update

  end

  def draw
    @background.draw
    @player.draw
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

end

Main.new.show
