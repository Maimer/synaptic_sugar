class Player

  attr_reader :angle, :bullets, :speed, :health
  attr_accessor :asteroid_count

  def initialize(window)
    @window = window
    @ship = Gosu::Image.new(window, 'images/ship/ship1.png')
    @ship_thrust = [Gosu::Image.new(window, 'images/ship/shipthrust1a.png'),
                    Gosu::Image.new(window, 'images/ship/shipthrust2a.png')]
    @bullet_images = Gosu::Image.load_tiles(window, "images/ship/missiles.png", 24, 45, false)
    @x = (window.width / 2).to_f
    @y = (window.height / 2).to_f
    @thrust = 0.0
    @x_vel = 0.0
    @y_vel = 0.0
    @current_thrust = false
    @angle = 0
    @side = -1
    @last_shot_time = Gosu::milliseconds
    @fired = false
    @bullets = []
    @speed = 0.0
    @health = 100.0
    @asteroid_count = 0
  end

  def update(asteroids, images)
    if Gosu::milliseconds - @last_shot_time >= 250
      @fired = false
      @last_shot_time = Gosu::milliseconds
    end

    if @window.button_down?(Gosu::KbUp)
      self.thrust
    end
    if @window.button_down?(Gosu::KbF)
      self.fire
    end
    if @window.button_down?(Gosu::KbRight)
      self.turn_right
    elsif @window.button_down?(Gosu::KbLeft)
      self.turn_left
    end

    radians = (@angle - 90) * Math::PI / 180.0
    x_comp = @thrust * Math.cos(radians)
    y_comp = @thrust * Math.sin(radians)

    if @current_thrust == true
      # if (Math.sqrt(((@x_vel + x_comp)**2) + ((@y_vel + y_comp)**2)) >= 10)

        # if @x_vel.abs > @y_vel.abs
        #   @x_vel -= y_comp
        #   @y_vel += y_comp
        # elsif @y_vel.abs > @x_vel.abs
        #   @x_vel += x_comp
        #   @y_vel -= x_comp
        # end
      # else
        @x_vel += x_comp
        @y_vel += y_comp
      # end
    else
      @thrust = 0
    end

    @x += @x_vel
    @y += @y_vel

    if @x > SCREEN_WIDTH then @x = 0 end
    if @x < 0 then @x = SCREEN_WIDTH end
    if @y > SCREEN_HEIGHT then @y = 0 end
    if @y < 0 then @y = SCREEN_HEIGHT end

    if @bullets.size != 0
      @bullets.each do |b|
        b.update
      end
      @bullets.reject! do |b|
        b.x < 0 || b.x > SCREEN_WIDTH || b.y < 0 || b.y > SCREEN_HEIGHT
      end
    end

    @speed = Math.sqrt(@x_vel**2 + @y_vel**2)

    if asteroids.size != 0
      asteroids.each do |asteroid|
        if Gosu::distance(@x, @y, asteroid.x, asteroid.y) < (images[asteroid.asteroid].width + @ship.width) / 2 - 10

          @health -= ((@x_vel - asteroid.x_vel) * images[asteroid.asteroid].width / 35).abs
          @health -= ((@y_vel - asteroid.y_vel) * images[asteroid.asteroid].width / 35).abs

          if @health < 0
            @health = 0
          end

          sx = @x_vel
          sy = @y_vel

          @x_vel = (sx * (@ship.width - images[asteroid.asteroid].width) + 2 * images[asteroid.asteroid].width * asteroid.x_vel) /
                   (@ship.width + images[asteroid.asteroid].width)
          @y_vel = (sy * (@ship.width - images[asteroid.asteroid].width) + 2 * images[asteroid.asteroid].width * asteroid.y_vel) /
                   (@ship.width + images[asteroid.asteroid].width)

          asteroid.x_vel = (asteroid.x_vel * (images[asteroid.asteroid].width - @ship.width) + 2 * @ship.width * sx) /
                           (@ship.width + images[asteroid.asteroid].width)
          asteroid.y_vel = (asteroid.y_vel * (images[asteroid.asteroid].width - @ship.width) + 2 * @ship.width * sy) /
                           (@ship.width + images[asteroid.asteroid].width)
        end
      end
    end
  end

  def draw
    if @current_thrust == false
      @ship.draw_rot(@x, @y, 10, @angle, 0.5, 0.46)
    elsif @current_thrust == true
      img = @ship_thrust[(Gosu::milliseconds / 25) % @ship_thrust.size]
      img.draw_rot(@x, @y, 10, @angle, 0.5, 0.46)
    end

    @current_thrust = false

    if bullets.size != 0
      bullets.each do |b|
        b.draw(@bullet_images)
      end
    end

    if @window.debug == true
      @window.draw_line(@x, @y, Gosu::Color::GREEN, @x + @ship.width, @y, Gosu::Color::GREEN, 20)
      @window.draw_line(@x, @y, Gosu::Color::GREEN, @x, @y + @ship.height, Gosu::Color::GREEN, 20)
      @window.draw_line(@x, @y + @ship.height, Gosu::Color::GREEN, @x + @ship.width, @y + @ship.height, Gosu::Color::GREEN, 20)
      @window.draw_line(@x + @ship.width, @y, Gosu::Color::GREEN, @x + @ship.width, @y + @ship.height, Gosu::Color::GREEN, 20)
    end
  end

  def fire
    if @fired == false
      @last_shot_time = Gosu::milliseconds
      @fired = true
      radians = (@angle - 90) * Math::PI / 180.0

      # if @side == -1
        bx = @x + (Math.sin(radians))
        by = @y + (Math.cos(radians))
      # end
      # if @side == 1
      #   bx = @x - (22 * Math.sin(radians))
      #   by = @y - (22 * Math.cos(radians))
      # end

      x_comp = 10 * Math.cos(radians)
      y_comp = 10 * Math.sin(radians)

      @bullets << Bullet.new(@window, bx, by, x_comp, y_comp, @angle)

      # @side == 1 ? @side = -1 : @side = 1
    end
  end

  def turn_right
    @angle += 5
    if @angle > 355 then @angle = 0 end
  end

  def turn_left
    @angle -= 5
    if @angle < 0 then @angle = 355 end
  end

  def thrust
    @current_thrust = true
    @thrust += 0.01
    if @thrust > 0.15 then @thrust = 0.15 end
  end
end
