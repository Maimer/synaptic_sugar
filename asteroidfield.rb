class AsteroidField

  attr_reader :asteroid_images, :rate
  attr_accessor :asteroids

  def initialize(window, player)
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
    @player = player
    @timer = Timer.new
    @increase = 0
    @rate = 0
  end

  def update(bullets)
    @rate = 30 - @increase
    @increase = (@timer.seconds / 2).to_i
    @timer.update
    if @rate < 5
      @rate = 5
    end

    asteroid_created = false

    if rand(@rate) == 0
      asteroid_image = rand(6)
      while asteroid_created == false
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
        new_asteroid = Asteroid.new(@window, x, y, x_vel, y_vel, asteroid_image)
        asteroid_created = true
        if @asteroids.size != 0
          @asteroids.each do |a|
            if Gosu::distance(a.x, a.y, new_asteroid.x, new_asteroid.y) < @asteroid_images[a.asteroid].width + @asteroid_images[new_asteroid.asteroid].width + 10
              asteroid_created = false
            end
          end
        end
        if asteroid_created == true
          @asteroids << new_asteroid
        end
      end
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
          if Gosu::distance(a.x, a.y, b.x, b.y) < @asteroid_images[a.asteroid].width / 2 + 10
            x = a.x - @explosion_images[0].width / 2
            y = a.y - @explosion_images[0].height / 2
            @explosions << Explosion.new(@window, x, y)
            @player.asteroid_count += 1
          end
        end
      end
    end

    if @asteroids.size != 0 && bullets.size != 0
      @asteroids.reject! do |a|
        bullets.reject! do |b|
          Gosu::distance(a.x, a.y, b.x, b.y) < @asteroid_images[a.asteroid].width / 2 + 10
        end
      end
    end

    if @explosions.size != 0
      @explosions.reject! do |e|
        Gosu::milliseconds - e.start > 300
      end
    end

    if @asteroids.size != 0
      @asteroids.each do |asteroid|
        asteroid.checked = false
      end
    end

    if @asteroids.size != 0
      @asteroids.each do |asteroid1|
        @asteroids.each do |asteroid2|
          if asteroid2.checked != true
            if asteroid1.object_id != asteroid2.object_id
              if Gosu::distance(asteroid1.x, asteroid1.y, asteroid2.x, asteroid2.y) < (@asteroid_images[asteroid1.asteroid].width + @asteroid_images[asteroid2.asteroid].width) / 2 - 10

                a1x = asteroid1.x_vel
                a1y = asteroid1.y_vel

                a1_image = @asteroid_images[asteroid1.asteroid].width
                a2_image = @asteroid_images[asteroid2.asteroid].width

                asteroid1.x_vel = (a1x * (a1_image - a2_image) + 2 * a2_image * asteroid2.x_vel) / (a1_image + a2_image)
                asteroid1.y_vel = (a1y * (a1_image - a2_image) + 2 * a2_image * asteroid2.y_vel) / (a1_image + a2_image)

                asteroid2.x_vel = (asteroid2.x_vel * (a2_image - a1_image) + 2 * a1_image * a1x) / (a1_image + a2_image)
                asteroid2.y_vel = (asteroid2.y_vel * (a2_image - a1_image) + 2 * a1_image * a1y) / (a1_image + a2_image)
              end
            end
          end
        end
        asteroid1.checked = true
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
