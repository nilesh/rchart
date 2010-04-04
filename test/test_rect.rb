require 'rubygems'
require 'ruby-debug'
require 'gd2'

class RChart
  SCALE_NORMAL = 1
  SCALE_ADDALL = 2
  SCALE_START0 = 3
  SCALE_ADDALLSTART0 = 4
  PIE_PERCENTAGE =  1
  PIE_LABELS = 2
  PIE_NOLABEL = 3
  PIE_PERCENTAGE_LABEL =  4
  TARGET_GRAPHAREA = 1
  TARGET_BACKGROUND = 2
  ALIGN_TOP_LEFT = 1
  ALIGN_TOP_CENTER = 2
  ALIGN_TOP_RIGHT = 3
  ALIGN_LEFT = 4
  ALIGN_CENTER = 5
  ALIGN_RIGHT = 6
  ALIGN_BOTTOM_LEFT = 7
  ALIGN_BOTTOM_CENTER = 8
  ALIGN_BOTTOM_RIGHT = 9

  def initialize(x_size,y_size,options={})
    # Initialize variables
    #    raise ArgumentError if (options[:x_size].nil? && options[:y_size].nil?)
    @x_size = x_size
    @y_size = y_size
    @error_reporting = false
    @error_font_name = "../fonts/pf_arma_five.ttf"
    @error_font_size = 6
    @currency = "Rs."
    @date_format = "%d/%m/%Y"
    @line_width = 1
    @line_dot_size = 0
    @anti_alias_quality = 0
    @shadow_active = false
    @shadow_x_distance = 1
    @shadow_y_distance = 1
    @shadow_r_color = 60
    @shadow_g_color = 60
    @shadow_b_color = 60
    @shadow_alpha = 50
    @shadow_blur = 0
    @tmp_dir = '/tmp'
    @picture = GD2::Image::TrueColor.new(@x_size, @y_size)
    @c_white = GD2::Color.new(255, 255, 255)
    point1 = GD2::Canvas::Point.new(0,0)
    point2 = GD2::Canvas::Point.new(@x_size, @y_size)
    rectangle = GD2::Canvas::FilledRectangle.new(point1, point2)
    rectangle.draw(@picture, @c_white.rgba)
    @picture.transparent = @c_white
    #  self.set_font_properties("tahoma.ttf", 8)
 end
   def set_font_properties(fontname, fontsize)
     @default_font = GD2::Font::TrueType.new(fontname, fontsize)
   end  
   #Set the shadow properties 
   def set_shadow_properties(s_x_distance=1,s_y_distance=1,s_r_color=60,s_g_color=60,s_b_color=60,s_alpha=50,s_blur=0)
     @shadow_active = true
     @shadow_x_distance = s_x_distance
     @shadow_y_distance = s_y_distance
     @shadow_r_color    = s_r_color
     @shadow_g_color    = s_g_color
     @shadow_b_color    = s_b_color
     @shadow_alpha      = s_alpha
     @shadow_blur       = s_blur
   end
    #remove shadow option
   def clear_shadow
     @shadow_active = false
   end  
    # Set line style
   def set_line_style(width=1,dot_size=0)
     @line_width = width
     @line_dot_size = dot_size
   end

   # Set currency symbol 
   def set_currency(currency)
     @currency = currency
   end
   # Set the graph area location *
   def set_graph_area(x1,y1,x2,y2)
     @garea_x1 = x1
     @garea_y1 = y1
     @garea_x2 = x2
     @garea_y2 = y2
   end 

    #ADDED 
   def image_filled_rectangle(picture,x1,y1,x2,y2,r,g,b)
    c_rectangle =  GD2::Color.new(r, g, b)
    point1 = GD2::Canvas::Point.new(x1,y1)
    point2 = GD2::Canvas::Point.new(x2, y2)
    rectangle = GD2::Canvas::FilledRectangle.new(point1, point2)
    rectangle.draw(picture, c_rectangle.rgba)
   end

   def image_copy_merge(src_pic,other, dst_x, dst_y, src_x, src_y, w, h, pct, gray = false)
     src_pic.merge_from(other, dst_x, dst_y, src_x, src_y, w, h, pct) 
   end

   def image_color_at(picture,x,y)
     pixel = picture.get_pixel(x,y) 
     color =picture.pixel2color(pixel)
     color.rgba
   end

   def image_set_pixel(picture,x,y,r,g,b)
    color = GD2::Color.new(r, g, b)
    picture.set_pixel(x,y,color.rgba)
   end

  def image_line(picture,x1,y1,x2,y2,line_color)
   point1 = GD2::Canvas::Point.new(x1,y1)
   point2 = GD2::Canvas::Point.new(x2, y2+1)
   line = GD2::Canvas::Line.new(point1,point2)
   line.draw(picture,line_color.rgba)
  end
  
  
  def draw_antialias_pixel(x,y,r,g,b,alpha=100,no_fall_back=false)
  #Process shadows 
    if(@shadow_active && !no_fall_back)
      self.draw_antialias_pixel(x+@shadow_x_distance,y+@shadow_y_distance,@shadow_r_color,@shadow_g_color,@shadow_b_color,@shadow_alpha,true)
      if(@shadow_blur != 0)
        alpha_decay = (@shadow_alpha / @shadow_blur)
        i=1
        while i<=@shadow_blur
          self.draw_antialias_pixel(x+@shadow_x_distance-i/2,y+@shadow_y_distance-i/2,@shadow_r_color,@shadow_g_color,@shadow_b_color,@shadow_alpha-alphaDecay*i,true)
          i = i+1
        end
        i =1   
        while i<=@shadow_blur
          self.draw_antialias_pixel(x+@shadow_x_distance+i/2,y+@shadow_y_distance+i/2,@shadow_r_color,@shadow_g_color,@shadow_b_color,@shadow_alpha-alpha_decay*i,true)
          i = i+1
        end 
      end
    end
    r = 0    if ( r < 0 )  
    r = 255  if ( r > 255 ) 
    g = 0    if ( g < 0 )    
    g = 255  if ( g > 255 )  
    b = 0    if ( b < 0 )    
    b = 255  if ( b > 255 )  
    plot = ""
    xi   = x.floor
    yi   = y.floor
    if ( xi == x && yi == y)
      if ( alpha == 100 )
         image_set_pixel(@picture,x,y,r,g,b)
      else
         self.draw_alpha_pixel(x,y,alpha,r,g,b)
      end
    else
      alpha1 = (((1 - (x - x.floor)) * (1 - (y - y.floor)) * 100) / 100) * alpha
      self.draw_alpha_pixel(xi,yi,alpha1,r,g,b) if alpha1 > @anti_alias_quality
      alpha2 = (((x -  x.floor) * (1 - (y - y.floor)) * 100) / 100) * alpha
      self.draw_alpha_pixel(xi+1,yi,alpha2,r,g,b) if alpha2 > @anti_alias_quality 
      alpha3 = (((1 - (x -  x.floor)) * (y - y.floor) * 100) / 100) * alpha
      self.draw_alpha_pixel(xi,yi+1,alpha3,r,g,b) if alpha3 > @anti_alias_quality 
      alpha4 = (((x -  x.floor) * (y - y.floor) * 100) / 100) * alpha
      self.draw_alpha_pixel(xi+1,yi+1,alpha4,r,g,b)  if alpha4 > @anti_alias_quality 
    end
  end


  # Prepare the graph area 
  def draw_graph_area(r,g,b,stripe=false)
    self.draw_filled_rectangle(@garea_x1,@garea_y1,@garea_x2,@garea_y2,r,g,b,false)
    self.draw_rectangle(@garea_x1,@garea_y1,@garea_x2,@garea_y2,r-40,g-40,b-40)
    if stripe
      r2 = r-15 
      r2 = 0 if r2<0
      g2 = r-15 
      g2 = 0  if g2 < 0
      b2 = r-15  
      b2 = 0  if b2 < 0
      line_color = allocate_color(r2,g2,b2)
      skew_width = @garea_y2-@garea_y1-1
      i = @garea_x1-skew_width
      while i<= @greax2
        x1 = i
        y1 = @garea_y2
        x2 = i+skew_width
        y2 = @garea_y1
        if ( x1 < @garea_x1 )
          x1 = @garea_x1
          y1 = @garea_y1 + x2 - @garea_x1 + 1
        end
        if ( x2 >= @garea_x2 )
          y2 = @garea_y1 + x2 - @garea_x2 +1
          x2 = @garea_x2 - 1 
        end
        image_line(@picture,x1,y1,x2,y2+1,line_color)
        i = i+4
      end
    end
  end
  def draw_background(r, g, b)

  end

  def draw_rectangle(x1, y1, x2, y2, r, g, b)
    r = 0    if ( r < 0 )  
    r = 255  if ( r > 255 ) 
    g = 0    if ( g < 0 )    
    g = 255  if ( g > 255 )  
    b = 0    if ( b < 0 )    
    b = 255  if ( b > 255 )  
    c_rectangle =  allocate_color(r, g, b)
    x1=x1-0.2
    y1=y1-0.2
    x2=x2+0.2
    y2=y2+0.2
    self.draw_line(x1,y1,x2,y1,r,g,b)
    self.draw_line(x2,y1,x2,y2,r,g,b)
    self.draw_line(x2,y2,x1,y2,r,g,b)
    self.draw_line(x1,y2,x1,y1,r,g,b)
  end

  def draw_filled_rectangle(x1, y1, x2, y2, r, g, b, draw_border=true, alpha=100,no_fall_back=false)
    x1, x2 = x2, x1  if x2 < x1 
    y1, y2 = y2, y1   if y2 < y1 
    r = 0    if ( r < 0 )  
    r = 255  if ( r > 255 ) 
    g = 0    if ( g < 0 )    
    g = 255  if ( g > 255 )  
    b = 0    if ( b < 0 )    
    b = 255  if ( b > 255 )  
    if(alpha == 100) 
      #Process shadows 
      if(@shadow_active && no_fall_back)
        self.draw_filled_rectangle(x1+@shadow_x_distance,y1+@shadow_y_distance,x2+@shadow_x_distance,y2+@shadow_y_distance,@shadow_r_color,@shadow_g_color,@shadow_b_color,false,@shadow_alpha,true)
        if(@shadow_blur != 0)
          alpha_decay = (@shadow_alpha/ @shadow_blur)
          i =1
          while i<=@shadow_blur
            self.draw_filled_rectangle(x1+@shadow_x_distance-i/2,y1+@shadow_y_distance-i/2,x2+@shadow_x_distance-i/2,y2+@shadow_y_distance-i/2,@shadow_r_color,@shadow_g_color,@shadow_b_color,false,@shadow_alpha-alpha_decay*i,true)
             i = i+1
          end
          i = 1
          while i<=@shadow_blur
            self.draw_filled_rectangle(x1+@shadow_x_distance+i/2,y1+@shadow_y_distance+i/2,x2+@shadow_x_distance+i/2,y2+@shadow_y_distance+i/2,@shadow_r_color,@shadow_g_color,@shadow_b_color,false,@shadow_alpha-alpha_decay*i,true)
            i = i+1
          end 
        end
      end
      image_filled_rectangle(@picture,x1.round,y1.round,x2.round,y2.round,r,g,b)
     else
       layer_width  = (x2-x1).abs+2
       layer_height = (y2-y1).abs+2
       @layers[0] = image = Image::TrueColor.new(layer_width,layer_height)
       c_white         = GD2::Color.new(255, 255, 255)
       image_filled_rectangle(@layers[0],0,0,layer_width,layer_height,255,255,255)
       @layer[0].transparent = c_white
       image_filled_rectangle(@layers[0],1.round,1.round,($LayerWidth-1).round,($LayerHeight-1).round,r,g,b)
       image_copy_merge(@picture,@layers[0],([x1,x2].min-1).round,([y1,y2]-1).min,0,0,layer_width,layer_height,alpha)
       #TODO Find out equivalent method
       #imagedestroy($this->Layers[0])
      end
     if (draw_border )
       shadow_settings = @shadow_active
       @shadow_active = false
      self.draw_rectangle(x1,y1,x2,y2,r,g,b)
      @shadow_active = shadow_settings
    end
  end

  def draw_rounded_rectangle(x1, y1, x2, y2, r, g, b)

  end

  def draw_filled_rounded_rectangle(x1, y1, x2, y2, r, g, b, draw_border=true, alpha=100)

  end

  def draw_circle(xc, yc, height, r, g, b, width)

  end

  def draw_filled_circle(xc, yc, height, r, g, b, width)

  end
  def allocate_color(r,g,b)
    GD2::Color.new(r, g, b)
  end
  #This function create a line with antialias 
  def draw_line(x1,y1,x2,y2,r,g,b,graph_function=false)
    if ( @line_dot_size > 1 )
      self.draw_dotted_line(x1,y1,x2,y2,@line_dot_size,r,g,b,graph_function)
    else
      r = 0    if ( r < 0 )  
      r = 255  if ( r > 255 ) 
      g = 0    if ( g < 0 )    
      g = 255  if ( g > 255 )  
      b = 0    if ( b < 0 )    
      b = 255  if ( b > 255 )  
      distance = Math.sqrt((x2-x1)*(x2-x1)+(y2-y1)*(y2-y1))  
      if ( distance == 0 )
        #return -1
      else  
        xstep = (x2-x1) / distance
        ystep = (y2-y1) / distance
        i =0
        while i<=distance   
          x = i * xstep + x1
          y = i * ystep + y1
          if((x >= @garea_x1 && x <= @garea_x2&& y >= @garea_y1 && y <= @garea_y2) || !graph_function )
            if ( @line_width == 1 )
              self.draw_antialias_pixel(x,y,r,g,b)
            else
              start_offset = -(@line_width/2) 
              end_offset = (@line_width/2)
              j = start_offset
              while j<=end_offset
                self.draw_antialias_pixel(x+j,y+j,r,g,b)
              end   
            end
          end
          i =i+1
        end
      end 
    end  
   end
  def draw_dotted_line(x1,y1,x2,y2,line_dot_size,r,g,b,graph_function)

  end
  # Draw an alpha pixel */
  def draw_alpha_pixel(x,y,alpha,r,g,b)
    r = 0    if ( r < 0 )  
    r = 255  if ( r > 255 ) 
    g = 0    if ( g < 0 )    
    g = 255  if ( g > 255 )  
    b = 0    if ( b < 0 )    
    b = 255  if ( b > 255 )  
    if ( x < 0 || y < 0 || x >= @x_size || y >= @y_size )
      #return(-1)
      #TODO check image_color_at method is right?
    else 
      rGB2 = image_color_at(@picture, x, y)
    #  debugger
      r2   = (rGB2 >> 16) & 0xFF
      g2   = (rGB2 >> 8) & 0xFF
      b2   = rGB2 & 0xFF
      ialpha = (100 - alpha)/100
      alpha  = alpha / 100
      ra   = (r*alpha+r2*ialpha).floor
      ga   = (g*alpha+g2*ialpha).floor
      ba   = (b*alpha+b2*ialpha).floor
      image_set_pixel(@picture,x,y,ra,ga,ba)
    end 
  end

  def render(picture)
    @picture.export('out.png', :format => :png)
  end 


end
ch = RChart.new(600,700)
ch.set_graph_area(70,30,680,200)
ch.draw_filled_rectangle(7,7,693,223,240,240,240);   
#ch.drawRoundedRectangle(5,5,695,225,5,230,230,230);   
ch.draw_graph_area(255,255,255,false);
ch.render(ch)


