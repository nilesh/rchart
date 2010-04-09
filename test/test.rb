require 'rubygems'
require 'gd2'
require 'ruby-debug'
picture = GD2::Image::TrueColor.new(100, 100)
red = GD2::Color.new(255,0,0)
green = GD2::Color.new(255,255,0)
point1 = GD2::Canvas::Point.new(0,0)
point2 = GD2::Canvas::Point.new(100, 100)
rectangle = GD2::Canvas::FilledRectangle.new(point1, point2)
rectangle.draw(picture, red.rgba)
picture.transparent = red

  font = GD2::Font::TrueType("/home/amar/projects/gem and plugin development/rchart/fonts/tahoma.ttf", 8]

picture.export('out.png', :format => :png)
