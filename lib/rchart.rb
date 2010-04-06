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
     @default_font = GD2::Font::TrueType[fontname, fontsize]
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
  #TODO check
  def image_ttf_text(picture,font_size,angle,xpos,ypos,fgcolor,font_name,value)
     #font = GD2::Font::TrueType[fontname, fontsize]
     #font.draw(picture, xpos, ypos, angle, value, fgc color) 
  end
  def image_ftb_box(font_size,angle,font_name,value)
    #font = GD2::Font::TrueType.new(fontname, fontsize)
    #font = bounding_rectangle(value, angle)
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
       #imagedestroy(self.Layers[0])
      end
     if (draw_border )
       shadow_settings = @shadow_active
       @shadow_active = false
      self.draw_rectangle(x1,y1,x2,y2,r,g,b)
      @shadow_active = shadow_settings
    end
  end

  def draw_rounded_rectangle(x1, y1, x2, y2, radius,r, g, b)
      r = 0    if ( r < 0)
      r = 255  if ( r > 255)
      g = 0    if ( g < 0)
      g = 255  if ( g > 255)
      b = 0    if ( b < 0)
      b = 255  if ( b > 255)

     c_rectangle = allocate_color(r,g,b)

     step = 90 / ((3.1418 * radius)/2)
     i=0
     while i<=90
       x = Math.cos((i+180)*3.1418/180) * radius + x1 + radius
       y = Math.sin((i+180)*3.1418/180) * radius + y1 + radius
       self.draw_antialias_pixel(x,y,r,g,b)

       x = Math.cos((i-90)*3.1418/180) * radius + x2 - radius
       y = Math.sin((i-90)*3.1418/180) * radius + y1 + radius
      self.draw_antialias_pixel(x,y,r,g,b)

       x = Math.cos((i)*3.1418/180) * radius + x2 - radius
       y = Math.sin((i)*3.1418/180) * radius + y2 - radius
       self.draw_antialias_pixel(x,y,r,g,b)

       x = Math.cos((i+90)*3.1418/180) * radius + x1 + radius
       y = Math.sin((i+90)*3.1418/180) * radius + y2 - radius
       self.draw_antialias_pixel(x,y,r,g,b)
       i=i+step
      end

     x1=x1-0.2
     y1=y1-0.2
     x2=x2+0.2
     y2=y2+0.2
     self.draw_line(x1+radius,y1,x2-radius,y1,r,g,b)
     self.draw_line(x2,y1+radius,x2,y2-radius,r,g,b)
     self.draw_line(x2-radius,y2,x1+radius,y2,r,g,b)
     self.draw_line(x1,y2-radius,x1,y1+radius,r,g,b)
  end

  def draw_filled_rounded_rectangle(x1, y1, x2, y2, radius,r, g, b, draw_border=true, alpha=100)
    r = 0    if ( r < 0)
    r = 255  if ( r > 255)
    g = 0    if ( g < 0)
    g = 255  if ( g > 255)
    b = 0    if ( b < 0)
    b = 255  if ( b > 255)
    c_rectangle = allocate_color(r,g,b)
    step = 90 / ((3.1418 * radius)/2)
      i=0
      while i<=90
       xi1 = Math.cos((i+180)*3.1418/180) * radius + x1 + radius
       yi1 = Math.sin((i+180)*3.1418/180) * radius + y1 + radius

       xi2 = Math.cos((i-90)*3.1418/180) * radius + x2 - radius
       yi2 = Math.sin((i-90)*3.1418/180) * radius + y1 + radius

       xi3 = Math.cos((i)*3.1418/180) * radius + x2 - radius
       yi3 = Math.sin((i)*3.1418/180) * radius + y2 - radius

       xi4 = Math.cos((i+90)*3.1418/180) * radius + x1 + radius
       yi4 = Math.sin((i+90)*3.1418/180) * radius + y2 - radius

       image_line(@picture,xi1,yi1,x1+radius,yi1,c_rectangle)
       image_line(@picture,x2-radius,yi2,xi2,yi2,c_rectangle)
       image_line(@picture,x2-radius,yi3,xi3,yi3,c_rectangle)
       image_line(@picture,xi4,yi4,x1+radius,yi4,c_rectangle)

       self.draw_antialias_pixel(xi1,yi1,r,g,b)
       self.draw_antialias_pixel(xi2,yi2,r,g,b)
       self.draw_antialias_pixel(xi3,yi3,r,g,b)
       self.draw_antialias_pixel(xi4,yi4,r,g,b)
       i=i+step
     end
     image_filled_rectangle(@picture,x1,y1+radius,x2,y2-radius,r,g,b)
     image_filled_rectangle(@picture,x1+radius,y1,x2-radius,y2,r,g,b)

     x1=x1-0.2
     y1=y1-0.2
     x2=x2+0.2
     y2=y2+0.2
     self.draw_line(x1+radius,y1,x2-radius,y1,r,g,b)
     self.draw_line(x2,y1+radius,x2,y2-radius,r,g,b)
     self.draw_line(x2-radius,y2,x1+radius,y2,r,g,b)
     self.draw_line(x1,y2-radius,x1,y1+radius,r,g,b)
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

   #Allow you to clear the scale : used if drawing multiple charts */
   def clear_scale

     @vmin       = nil
     @vmax        = nil
     @vxmin      = nil
     @vxmax      = nil
     @divisions  = nil
     @xdivisions = nil
   end

   # Allow you to fix the scale, use this to bypass the automatic scaling */
   def set_fixed_scale(vmin,vmax,divisions=5,vxmin=0,vxmax=0,xdivisions=5)
     @vmin      = vmin
     @vmax      = vmax
     @divisions = divisions
     #TODO check
     #if (!vxnin == 0 )
      if (vxnin != 0 )
       @vxmin      = vxmin
       @vxmax      = vxmax
       @xdivisions = xdivisions
     end
   end
 #Validate data contained in the data array
   def validate_data(function_name,data)
      data_summary = {}
     data.each do |v|
       v.each do |key,val|
         if (data_summary[key].nil?)
           data_summary[key] = 1
         else
           data_summary[key] = data_summary[key]+1
         end
       end
     end
     if ( data_summary.max == 0 ) #TODO Check method
       puts "No data set."
     data_summary.each do |k,v|
      if v < data_summary.max
        puts "#{function_name} Missing Data in serie #{key}"
      end
    end
  end
   #Wrapper to the drawScale() function allowing a second scale to be drawn */
   def draw_right_scale(data,data_description,scale_mode,r,g,b,draw_ticks=true,angle=0,decimals=1,with_margin=false,skip_labels=1)

     self.draw_scale(data,data_description,scale_mode,r,g,b,draw_ticks,angle,decimals,with_margin,skip_labels,true)
    end
  end

  def render(picture)
    @picture.export('out.png', :format => :png)
  end
#Convert seconds to a time format string */
   def to_time(value)

     hour   = (value/3600).floor
     minute = ((value - hour*3600)/60).floor
     second =(value - hour*3600 - minute*60).floor

     hour = "0.#{Hour}"  if (hour.length == 1 )
     minute = "0.#{minute}"    if (minute.length == 1 )
     second = "0.#{second}"  if (second.length == 1 )

     return ("#{hour}.:.#{minute}}.:.#{second}")
   end

   # Convert to metric system */
   #TODO Check Return statement
   def to_metric(value)
     go = (value/1000000000).floor
     mo = ((value - go*1000000000)/1000000).floor
     ko = ((value - go*1000000000 - mo*1000000)/1000).floor
     o  = (value - go*1000000000 - mo*1000000 - ko*1000).floor

     return("#{go}..#{mo}.g")   if (go != 0)
     return("#{mo}...#{ko}.m")   if (mo != 0)
     return("#{ko}...#{o}).k")   if (ko != 0)
     return(o);
   end

#   /* Convert to curency */
   def to_currency(value)
     go = (value/1000000000).floor
     mo = ((value - go*1000000000)/1000000).floor
     ko = ((value - go*1000000000 - mo*1000000)/1000).floor
     o  = (value - go*1000000000 - mo*1000000 - ko*1000).floor

      o = "00.#{o}"  if ( (o.length) == 1 )
     o = "0.#{o}"   if ( (o.length) == 2 )

     result_string = o;
     result_string = "#{ko}...#{result_string}"   if ( ko != 0 )
     result_string = "#{mo}...#{result_string}"   if ( mo != 0 )
     result_string = "#{go}...#{result_string}"   if ( go != 0 )

     result_string = @currency.result_strin
     return(result_string)
    end

   #Set date format for axis labels */
   def set_date_format(format)
    @date_format = format
   end

   # Convert TS to a date format string
   #TODO Concvert Date i
    def to_date(value)
   #  return(date($this->DateFormat,value));
   end
#Compute and draw the scale */
   def draw_scale(data,data_description,scale_mode,r,g,b,draw_ticks=true,angle=0,decimals=1,with_margin=false,skip_labels=1,right_scale=false)
     # Validate the Data and DataDescription array
     self.validate_data("draw_scale",data)
     c_text_color         = allocate_color(r,g,b)
     self.draw_line(@garea_x1,@garea_y1,@garea_x1,@garea_y2,r,g,b)
     self.draw_line(@garea_x1,@garea_y2,@garea_x2,@garea_y2,r,g,b)
     if(@vmin.nil? && @vmax.nil?)
        if (!data_description["values"][0].nil?)
         @vmin =data[0][data_description["values"][0]]
         @vmax =data[0][data_description["values"][0]]
       else
         @vmin = 2147483647
          @vmax = -2147483647
       end

#       /* Compute Min and Max values */
       if(scale_mode == SCALE_NORMAL || scale_mode == SCALE_START0)
          @vmin = 0 if (scale_mode == SCALE_START0 )
          data.each do |key|
            data_description["Values"].each do |col_name|
              if(!data[key][col_name])
                value = data[key][col_name]
                if (value.is_a?(Numeric))
                  @vmax = value if ( @vmax < value)
                  @vmin = value  if ( @vmin > value)
                end
              end
            end
          end
        elsif ( scale_mode == SCALE_ADDALL || scale_mode == SCALE_ADDALLSTART0 ) # Experimental
          @vmin = 0 if (scale_mode == SCALE_ADDALLSTART0)
          data.each do |key|
            sum = 0
            data_description["values"].each do|col_name|
              if (data[key][col_name].nil?)
                value =data[key][col_name]
                sum  += value if ((value).is_a?(Numeric))
              end
            end
            @vmax = sum if (@vmax < sum)
            @vmin = sum if (@vmin > sum)
          end
        end

        @vmax = @vmax.gsub(/\.[0-9]+/,'')+1 if (@vmax > @vmax.gsub(/\.[0-9]+/,'') )

       # If all values are the same */
       if ( @vmax == @vmin )
         if ( @vmax >= 0 )
           @vmax = @vmax+1
         else
           @vmin = @vmin-1
         end
       end

       data_range = @vmax - @vmin
       data_range = 0.1 if (data_range == 0 )

       #Compute automatic scaling */
       scale_ok = false
       factor = 1
       min_div_height = 25
       max_divs = (@garea_y2 - @garea_y1) / min_div_height

       if ( @vmin == 0 && @vmax == 0 )
           @vmin = 0
           @vmax = 2
           scale = 1
           divisions = 2
       elsif (max_divs > 1)
         while(!scale_ok)
           scale1 = ( @vmax - @vmin ) / factor
           scale2 = ( @vmax - @vmin ) /factor / 2
           scale4 = ( @vmax - @vmin ) / factor / 4

           if ( scale1 > 1 && scale1 <= max_divs && !scale_ok)
             scale_ok = true
             divisions = (scale1).floor
             scale = 1
           end
           if (scale2 > 1 && scale2 <= max_divs && !scale_ok)
             scale_ok = true
             divisions = (scale2).floor
             scale = 2
            end
           if (!scale_ok)
             factor = factor * 10 if ( scale2 > 1 )
             factor = factor / 10  if ( scale2 < 1 )
           end
         end # while end

         if ( (@vmax / scale / factor).floor != @vmax / scale / factor)

           grid_id     = ( @vmax / scale / factor).floor  + 1
           @vmax       = grid_id * scale * factor
           divisions   = divisions+1
         end

         if ((@vmin / scale / factor).floor != @vmin / scale / factor)

           grid_id     = ( @vmin / scale / factor).floor
           @vmin       = grid_id * scale * factor
           divisions   = divisions+1
         end

       else #/* Can occurs for small graphs */
        scale = 1
       end
        divisions = 2 if ( divisions.nil? )

        divisions = divisions -1 if (scale == 1 && divisions%2 == 1)

    else
     divisions = @divisions
    end
    @division_count = divisions
    data_range = @vmax - @vmin
    data_range = 0.1  if (data_range == 0 )
    @division_height = ( @garea_y2 - @garea_y1 ) / divisions
    @division_ratio  = ( @garea_y2 - @garea_y1 ) /data_range
    @g_area_x_offset  = 0
      if ( data.count > 1 )
        if ( decimals == false)
          @division_width = ( @garea_x2 - @garea_x1 ) / (data).count-1
        else
          @division_width = ( @garea_x2 - @garea_x1 ) / (data).count
          @g_area_x_offset  = @division_width / 2
        end
      else
        @division_width = @garea_x2 - @garea_x1
        @g_area_x_offset  = @division_width / 2
      end
      @data_count = (data).count
      return(0) if (draw_ticks == false )
      ypos = @garea_y2
      xmin = nil
      i =1
      while(i<=divisions+1)
        if (right_scale )
          self.draw_line(@garea_x2,ypos,@garea_x2+5,ypos,r,g,b)
        else
          self.draw_line(@garea_x1,ypos,@garea_x1-5,ypos,r,g,b)
        end
        value     = @vmin + (i-1) * (( @vmax - @vmin ) / divisions)
        value     = (value * (10**decimals)).round / (10**decimals)
        value = value.data_description["unit"]["y"]  if ( data_description["format"]["y"] == "number" )
        value = self.to_time(value)                  if ( data_description["format"]["y"] == "time" )
        value = self.to_date(value)                  if ( data_description["format"]["y"] == "date" )
        value = self.to_metric(value)                if ( data_description["format"]["Y"] == "metric" )
        value = self.to_currency(value)             if ( data_description["format"]["Y"] == "currency" )
        position  = image_ftb_box(@font_size,0,@font_name,value)
        text_width =position[2]-position[0]
        if ( right_scale )
          image_ttf_text(@picture,@font_size,0,@garea_x2+10,ypos+(@font_size/2),c_text_color,@font_name,value)
          xmin = @garea_x2+15+text_width if ( xmin < @garea_x2+15+text_width || xmin.nil? )
        else
          image_ttf_text(@picture,@font_size,0,@garea_x1-10-text_width,ypos+(@font_size/2),c_text_color,@font_name,value)
          xmin = @garea_x1-10-text_width if ( xmin > @garea_x1-10-text_width || xmin.nil? )
        end
        ypos = ypos - @division_height
        i = i+1
      end
      # Write the Y Axis caption if set */
    if ( !data_description["axis"]["y"].nil? )
      position   = image_ftb_box(@font_size,90,@font_name,data_description["axis"]["y"])
      text_height = (position[1]).abs+(position[3]).abs
      text_top    = ((@garea_y2 - @garea_y1) / 2) + @garea_y1 + (text_height/2)
      if ( right_scale )
        image_ttf_text(@picture,@font_size,90,xmin+@font_size,text_top,c_text_color,@font_name,data_description["axis"]["y"])
      else
        image_ttf_text(@picture,@font_size,90,xmin-@font_size,text_top,c_text_color,@font_name,data_description["axis"]["y"])
      end
    end  
      # Horizontal Axis */
      xpos = @garea_x1 + @g_area_x_offset
      id = 1
      ymax = nil
      data.each do |key|
        if ( id % skip_labels == 0 )
          self.draw_line((xpos).floor,@garea_y2,(xpos).floor,@garea_y2+5,r,g,b)
          value      =data[key][data_description["position"]]
          value = value.data_description["unit"]["x"] if ( data_description["format"]["x"] == "number" )
          value = self.to_time(value)       if ( data_description["format"]["x"] == "time" )
          value = self.to_date(value)       if ( data_description["format"]["x"] == "date" )
          value = self.to_metric(value)     if ( data_description["format"]["x"] == "metric" )
          value = self.to_currency(value)   if ( data_description["format"]["x"] == "currency" )
          position   = image_ftb_box(@font_size,angle,@font_name,value)
          text_width  = (position[2]).abs+abs(position[0]).abs
          text_height = (position[1]).abs+(position[3]).abs
          if ( angle == 0 )
            ypos = @garea_y2+18
            image_ttf_text(@picture,@font_size,angle,(xpos).floor-(text_width/2).floor,ypos,c_text_color,@font_name,value)
          else
             ypos = @garea_y2+10+$TextHeight
              if ( angle <= 90 )
                image_ttf_text(@picture,@font_size,angle,(xpos).floor-text_width+5,ypos,c_text_color,@font_name,value)
              else
                image_ttf_text(@picture,@font_size,angle,(xpos).floor+text_width+5,ypos,c_text_color,@font_name,value)
              end  
           end
        ymax = ypos if (ymax < ypos || ymax.nil? )
      end
      xpos = xpos + @division_width
      id = id+1
    end   #loop ended
    #Write the X Axis caption if set */
    if ( !(data_description["axis"]["x"]).nil? )
      position   = image_ftb_box(@font_size,90,@font_name,data_description["axis"]["x"])
      text_width  = (position[2]).abs+(position[0]).abs
      text_left   = ((@garea_x2 - @garea_x1) / 2) + @garea_x1 + (text_width/2)
      image_ttf_text(@picture,@font_size,0,text_left,ymax+@font_size+5,c_text_color,@font_name,data_description["axis"]["x"])
    end
  end
  #Compute and draw the scale 
   def draw_treshold(value,r,g,b,show_label=false,show_on_right=false,tick_width=4,free_text=nil)
      r = 0    if ( r < 0 )
      r = 255  if ( r > 255 )
      g = 0    if ( g < 0 )
      g = 255  if ( g > 255 )
      b = 0    if ( b < 0 )
      b = 255  if ( b > 255 )

     c_text_color =allocate_color(r,g,b)
     y = @g_area_y2 - (value - @vmin) * @division_ratio

     return(-1) if ( y <= @g_area_y1 || y >= @g_area_y2 )
      if ( tick_width == 0 )
        self.draw_Line(@g_area_x1,y,@g_area_x2,y,r,g,b)  
      else
       self.draw_dotted_line(@g_area_x1,y,@g_area_x2,y,tick_width,r,g,b);
      end
     if (show_label )
        if ( free_text.nil? )
          label = value
        else  
          label = free_text
        end
        
        if ( show_on_right )
          image_ttf_text(@picture,@font_size,0,@g_area_x2+2,y+(@font_size/2),c_text_color,@font_name,label)
        else
          image_ttf_text(@picture,@font_size,0,@g_area_x1+2,y-(@font_size/2),c_text_color,@font_name,label)
        end 
     end
   end
end

ch = RChart.new(700,230)
ch.set_graph_area(70,30,680,200)
ch.draw_filled_rounded_rectangle(7,7,693,223,5,240,240,240)
ch.draw_rounded_rectangle(5,5,695,225,5,230,230,230)
ch.draw_graph_area(255,255,255,false)
#ch.render(ch)


