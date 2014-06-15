class Player

  attr_reader :angle, :bullets

  def initialize(window)
    @window = window
    @ship = Gosu::Image.new(window, 'images/ship/ship1.png')
    @ship_thrust = [Gosu::Image.new(window, 'images/ship/shipthrust1a.png'),
                    Gosu::Image.new(window, 'images/ship/shipthrust2a.png')]
    @bullet_images = Gosu::Image.load_tiles(window, "images/ship/missiles.png", 24, 45, false)
    @x = ((window.width / 2) - (@ship.width / 2)).to_f
    @y = ((window.height / 2) - (@ship.width / 2)).to_f
    @cx = @x + (@ship.width / 2)
    @cy = @y + (@ship.width * 0.46)
    @thrust = 0.0
    @x_vel = 0.0
    @y_vel = 0.0
    @current_thrust = false
    @angle = 0
    @side = -1
    @last_shot_time = Time.now
    @fired = false
    @bullets = []
  end

  def update
    radians = (@angle - 90) * Math::PI / 180.0
    x_comp = @thrust * Math.cos(radians)
    y_comp = @thrust * Math.sin(radians)

    if @current_thrust == true
      # if (Math.sqrt(((@x_vel + x_comp)**2) + ((@y_vel + y_comp)**2)) >= 10) && @x_vel > 0
      #   @y_vel += y_comp
      #   @x_vel -= y_comp
      # elsif (Math.sqrt(((@x_vel + x_comp)**2) + ((@y_vel + y_comp)**2)) >= 10) && @x_vel < 0
      #   @y_vel += y_comp
      #   @x_vel -= y_comp
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

    if Time.now - @last_shot_time > 0.25
      @fired = false
      @last_shot_time = Time.now
    end

    if @bullets.size != 0
      @bullets.each do |b|
        b.update
      end
      @bullets.reject! do |b|
        b.x < 0 || b.x > SCREEN_WIDTH || b.y < 0 || b.y > SCREEN_HEIGHT
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
  end

  def fire
    if @fired == false
      radians = (@angle - 90) * Math::PI / 180.0
      bx = 0
      by = 0
      if @side == -1
        bx = @x + (22 * Math.sin(radians))
        yx = @y + (22 * Math.cos(radians))
      end
      if @side == 1
        bx = @x - (22 * Math.sin(radians))
        yx = @y - (22 * Math.cos(radians))
      end

      x_comp = 10 * Math.cos(radians)
      y_comp = 10 * Math.sin(radians)

      @bullets << Bullet.new(@window, bx, yx, x_comp, y_comp, @angle)
      @fired = true
      @side == 1 ? @side = -1 : @side = 1
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
