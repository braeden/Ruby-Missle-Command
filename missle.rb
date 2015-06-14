require 'ray'
Ray.game "Missle Command", :size => [800, 600] do
  register { add_hook :quit, method(:exit!) }
  scene :square do
    @miss_vel_x = 0.0
    @miss_vel_y = 0.0
    @score=0
    @level=2
    @lives = 5
    @enmissles = @level.times.map do
      m = Ray::Polygon.circle([0, 0], 5, Ray::Color.red)
      m.pos = [rand(0...800),rand(-100...-10)]
      m
    end
    @command = Ray::Polygon.rectangle([0, 0, 20, 5], Ray::Color.white)
    @command.pos = [400, 600]
    @pmissles = 1.times.map do
      m = Ray::Polygon.circle([0, 0], 5, Ray::Color.blue)
      m.pos = [400,590]
      m
    end
    always do
      @enmissles.each do |m|
        m.pos += [0,1]
        if m.pos.y > 600
          @enmissles.delete(m)
          @lives -= 1
        end
      end
      if @enmissles.empty?
        @level+=2
        @enmissles += @level.times.map do
          m = Ray::Polygon.circle([0, 0], 5, Ray::Color.red)
          m.pos = [rand(0...800),rand(-100...-10)]
          m
        end
      end
      on :mouse_motion do |pos|
        angle = Math::atan2(pos.y - 590, pos.x - 400)
        #convert points to radians
        degangle = angle * 180 / Math::PI
        #convert to degrees
        @command.angle = degangle
        #.pos = pos
      end

      on :mouse_press do |button, pos|
        if rand(50)==3
          @pmissles += 1.times.map do
            m = Ray::Polygon.circle([0, 0], 5, Ray::Color.blue)
            m.pos = [400,590]
            m
          end
          y=pos.y-590
          x=pos.x-400
          @miss_vel_x=x/50
          @miss_vel_y=y/50
        end
      end
      @pmissles.each do |m|
        m.pos += [@miss_vel_x, @miss_vel_y]
        if m.pos.y < 0
          @pmissles.delete(m)
        elsif m.pos.x < 0
          @pmissles.delete(m)
        elsif m.pos.x > 800
          @pmissles.delete(m)
        end
        @enmissles.each do |a|
          if [a.pos.x, a.pos.y, 10, 10].to_rect.collide?([m.pos.x, m.pos.y, 10, 10])
            @enmissles.delete(a)
            @pmissles.delete(m)
            @score += 500
          end
        end
      end
      on :key_press, key(:p) do
        if @paused == true
          @paused = false
        else
          @paused = true
        end
      end

    end
    render do |win|
      if @lives <= 0
        win.draw text("YOU LOST", :at => [180,180], :size => 60)
        win.draw text("Score:" + @score.to_s, :at => [0,0], :size => 20)
      else
        win.draw text("Lives:" + @lives.to_s, :at => [0,0], :size => 20)
        win.draw text("Score:" + @score.to_s, :at => [100,0], :size => 20)
        @enmissles.each do |m|
          win.draw m
        end
        @pmissles.each do |m|
          win.draw m
        end
        win.draw @command
      end
    end
  end
  scenes << :square
end
