require 'gosu'

require_relative 'player'
require_relative 'background'
require_relative 'bullet'
require_relative 'asteroidfield'
require_relative 'asteroid'
require_relative 'explosion'
require_relative 'timer'

SCREEN_WIDTH = 1440
SCREEN_HEIGHT = 1024

class Main < Gosu::Window

  attr_reader :debug

  def initialize
    super(SCREEN_WIDTH, SCREEN_HEIGHT, false)
    self.caption = "Synaptic Sugar"

    @background = Background.new(self)
    @player = Player.new(self)
    @asteroidfield = AsteroidField.new(self)
    @small_font = Gosu::Font.new(self, "Tahoma", SCREEN_HEIGHT / 20)
    @debug = false
  end

  def update
    @player.update(@asteroidfield.asteroids, @asteroidfield.asteroid_images)
    @asteroidfield.update(@player.bullets)
  end

  def draw
    @background.draw
    @player.draw
    @asteroidfield.draw
    draw_text(15, -10, "Speed: #{@player.speed.round(2)}", @small_font, Gosu::Color::WHITE)
    draw_rect(SCREEN_WIDTH / 2 - 200, 15, @player.health * 4, 30, 0xFFB00C00)
    draw_rect(SCREEN_WIDTH / 2 - 205, 10, 410, 5, 0xFF7A7A7A)
    draw_rect(SCREEN_WIDTH / 2 - 205, 45, 410, 5, 0xFF7A7A7A)
    draw_rect(SCREEN_WIDTH / 2 - 205, 15, 5, 30, 0xFF7A7A7A)
    draw_rect(SCREEN_WIDTH / 2 + 200, 15, 5, 30, 0xFF7A7A7A)


  end

  def button_down(id)
    if id == Gosu::KbEscape
      close
    end
    if id == Gosu::KbB
      @debug == true ? @debug = false : @debug = true
    end
  end

  def draw_text(x, y, text, font, color)
    font.draw(text, x, y, 3, 1, 1, color)
  end

  def draw_rect(x, y, width, height, color)
    draw_quad(x, y, color,
      x + width, y, color,
      x + width, y + height, color,
      x, y + height, color, 10)
  end
end

Main.new.show
