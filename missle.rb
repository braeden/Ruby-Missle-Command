require 'ray'
Ray.game "Missle Command", :size => [800, 600] do
  register { add_hook :quit, method(:exit!) }
  scene :square do
    @paused = false
    @miss_vel_x = 0
    @miss_vel_y = 0
    @enmissles = 6.times.map do
      m = Ray::Polygon.circle([200, 40], 5, Ray::Color.red)
      m.pos = [rand(0...800),rand(-100...-10)]
      m
    end
    @pmissles = []
    @command = Ray::Polygon.rectangle([0, 0, 20, 5], Ray::Color.white)
    @command.pos = [400, 600]
    always do
      @enmissles.each do |m|
        m.pos += [0,0.5]
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
        angle = Math::atan2(pos.y - 590, pos.x - 400)
        degangle = angle * 180 / Math::PI
        @miss_vel_x += Math::sin(degangle / (180 / Math::PI)) * 0.5
        @miss_vel_y -= Math::cos(degangle / (180 / Math::PI)) * 0.5
        @pmissles = 1.times.map do
          m = Ray::Polygon.circle([400, 600], 5, Ray::Color.blue)
          m.pos = [400,600]
        end
      end
      @pmissles.each do |m|
        m.pos += [@miss_vel_x, @miss_vel_y]
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
      if @paused == true
        win.draw text("Paused - Press P to resume", :at => [300,250], :size => 20)
      else
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
