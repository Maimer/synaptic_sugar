class AsteroidField

  attr_accessor :asteroids

  def initialize(window)
    @window = window
    @asteroid_images = [Gosu::Image.new(@window, "images/asteroids/a1.png"),
                        Gosu::Image.new(@window, "images/asteroids/a2.png"),
                        Gosu::Image.new(@window, "images/asteroids/a3.png"),
                        Gosu::Image.new(@window, "images/asteroids/a4.png"),
                        Gosu::Image.new(@window, "images/asteroids/a5.png"),
                        Gosu::Image.new(@window, "images/asteroids/a6.png")]
    @asteroids = []
    @explosion_images = Gosu::Image.load_tiles(@window, "images/explosion.png", 106, 98, false)
    @explosions = []
  end

  def update(bullets)
    if rand(20) + 1 == 1
      random = rand(4)
      if random == 0
        x = rand(SCREEN_WIDTH) + 1
        y = -100
        if rand(2) == 1
          x_vel = rand(4) + 1
        else
          x_vel = -(rand(4) + 1)
        end
        y_vel = rand(4) + 1
      elsif random == 1
        x = rand(SCREEN_WIDTH) + 1
        y = SCREEN_HEIGHT + 100
        if rand(2) == 1
          x_vel = rand(4) + 1
        else
          x_vel = -(rand(4) + 1)
        end
        y_vel = -(rand(4) + 1)
      elsif random == 2
        x = -100
        y = rand(SCREEN_HEIGHT) + 1
        if rand(2) == 1
          y_vel = rand(4) + 1
        else
          y_vel = -(rand(4) + 1)
        end
        x_vel = (rand(4) + 1)
      else
        x = SCREEN_WIDTH + 100
        y = rand(SCREEN_HEIGHT) + 1
        if rand(2) == 1
          y_vel = rand(4) + 1
        else
          y_vel = -(rand(4) + 1)
        end
        x_vel = -(rand(4) + 1)
      end
      @asteroids << Asteroid.new(@window, x, y, x_vel, y_vel)
    end

    if @asteroids.size != 0
      @asteroids.each do |a|
        a.update
      end
      @asteroids.reject! do |a|
        a.x < -100 || a.x > SCREEN_WIDTH + 100 || a.y < -100 || a.y > SCREEN_HEIGHT + 100
      end
    end

    if @asteroids.size != 0 && bullets.size != 0
      @asteroids.each do |a|
        bullets.each do |b|
          if Gosu::distance(a.x, a.y, b.x, b.y) < @asteroid_images[a.asteroid].width / 2
            x = a.x - @explosion_images[0].width / 2
            y = a.y - @explosion_images[0].height / 2
            @explosions << Explosion.new(@window, x, y)
          end
        end
      end
    end

    if @asteroids.size != 0 && bullets.size != 0
      @asteroids.reject! do |a|
        bullets.reject! do |b|
          Gosu::distance(a.x, a.y, b.x, b.y) < @asteroid_images[a.asteroid].width / 2
        end
      end
    end

    if @explosions.size != 0
      @explosions.reject! do |e|
        Gosu::milliseconds - e.start > 320
      end
    end
  end

  def draw
    if @asteroids.size != 0
      @asteroids.each do |a|
        a.draw(@asteroid_images)
      end
    end

    if @explosions.size != 0
      @explosions.each do |e|
        e.draw(@explosion_images)
      end
    end
  end
end
