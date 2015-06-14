require 'ray'
Ray.game "Missle Command", :size => [800, 600] do
  register { add_hook :quit, method(:exit!) }
  scene :square do
    @missle = Ray::Polygon.circle([200, 40], 5, Ray::Color.red)
    @missle.pos = [100,100]
    
    always do

    end
    render do |win|
      win.draw @missle
    end
  end
  scenes << :square
end
