require 'gosu'

require_relative 'player'
require_relative 'background'
require_relative 'bullet'
require_relative 'timer'

SCREEN_WIDTH = 1440
SCREEN_HEIGHT = 1024

class Main <Gosu::Window

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Synaptic Sugar"

    @background = Background.new(self)
    @player = Player.new(self)
    @small_font = Gosu::Font.new(self, "Tahoma", SCREEN_HEIGHT / 20)
  end

  def update
    if button_down?(Gosu::KbUp)
      @player.thrust
    end
    if button_down?(Gosu::KbF)
      @player.fire
    end
    if button_down?(Gosu::KbRight)
      @player.turn_right
    elsif button_down?(Gosu::KbLeft)
      @player.turn_left
    end
    @player.update
  end

  def draw
    @background.draw
    @player.draw
    if @player.bullets.size != 0
      @player.bullets.draw
    end
    draw_text(15, -10, "Angle: #{@player.angle}", @small_font, Gosu::Color::WHITE)
  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
  end

  def draw_text(x, y, text, font, color)
    font.draw(text, x, y, 3, 1, 1, color)
  end
end

Main.new.show
