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
#debugger
#font = GD2::Font.draw(picture,10,10,0,"Tahoma.ttf", green)
#set_font_properties("tahoma.ttf", 8)
picture.draw do |pen|
  pen.font = GD2::Font::TrueType["/home/amar/projects/gem and plugin development/rchart/fonts/tahoma.ttf", 8]
#pen.font.draw(pictur)
  pen.text "hhhhhh"
  
#  debugger
end
#    font = bounding_rectangle("hello ", 0.5)
picture.export('out.png', :format => :png)
