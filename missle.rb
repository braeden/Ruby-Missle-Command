require 'ray'
Ray.game "Missle Command", :size => [800, 600] do
  register { add_hook :quit, method(:exit!) }
  scene :square do
    @missles = 4.times.map do
      m = Ray::Polygon.circle([200, 40], 5, Ray::Color.red)
      m.pos = [rand(0...800),rand(-50...-10)]
    end
    always do
      @missles.each do
        @missle.pos += [0,2]
      end
    end
    render do |win|
      win.draw @missles.each
    end
  end
  scenes << :square
end
