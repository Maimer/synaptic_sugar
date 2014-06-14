require 'gosu'

require_relative 'player'
require_relative 'background'
require_relative 'bullet'
require_relative 'asteroid'
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
    @asteroid_images = [Gosu::Image.new(self, "images/asteroids/a1.png"),
                        Gosu::Image.new(self, "images/asteroids/a2.png"),
                        Gosu::Image.new(self, "images/asteroids/a3.png"),
                        Gosu::Image.new(self, "images/asteroids/a4.png"),
                        Gosu::Image.new(self, "images/asteroids/a5.png"),
                        Gosu::Image.new(self, "images/asteroids/a6.png")]
    @asteroids = []
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
    @player.update(@asteroids)

    if rand(20) + 1 == 1
      random = rand(4)
      if random == 0
        x = rand(SCREEN_WIDTH) + 1
        y = -100
      elsif random == 1
        x = rand(SCREEN_WIDTH) + 1
        y = SCREEN_HEIGHT + 100
      elsif random == 2
        x = -100
        y = rand(SCREEN_HEIGHT) + 1
      else
        x = SCREEN_WIDTH + 100
        y = rand(SCREEN_WIDTH) + 1
      end
      @asteroids << Asteroid.new(self, x, y)
    end

    @asteroids.each do |a|
      a.update
    end

    @player.bullets.reject! do |b|
      b.x < 0 || b.x > SCREEN_WIDTH || b.y < 0 || b.y > SCREEN_HEIGHT
    end
  end

  def draw
    @background.draw
    @player.draw
    if @asteroids.size != 0
      @asteroids.each do |a|
        a.draw(@asteroid_images)
      end
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
