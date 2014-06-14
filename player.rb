class Player

  attr_reader :angle, :bullets

  def initialize(window)
    @window = window
    @ship = Gosu::Image.new(window, 'images/ship.png')
    @ship_thrust = [Gosu::Image.new(window, 'images/shipthrust1.png'),
                    Gosu::Image.new(window, 'images/shipthrust2.png')]
    @bullets = Gosu::Image.load_tiles(self, "images/missiles.png", 32, 60, false)
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
    @timer = Timer.new
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
  end

  def draw
    if @current_thrust == false
      @ship.draw_rot(@x, @y, 10, @angle, 0.5, 0.46)
    elsif @current_thrust == true
      img = @ship_thrust[(Gosu::milliseconds / 25) % @ship_thrust.size]
      img.draw_rot(@x, @y, 10, @angle, 0.5, 0.46)
    end

    @current_thrust = false
  end

  def fire

    bx = 0
    if @side == -1 then bx = @x + 18 end
    if @side == 1 then bx = @x + 60 end
    @bullets << Bullet.new(@window, bx, @y, @x_vel, @y_vel)
  end

  def turn_right
    @angle += 5
    if @angle > 355 then @angle = 0 end
  end

  def turn_left
    @angle -= 5
    if @angle < -355 then @angle = 0 end
  end

  def thrust
    @current_thrust = true
    @thrust += 0.02
    if @thrust > 2 then @thrust = 2 end
  end
end
