require 'ruby-gd'

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
  
  def initialize(options={})
    
    # Initialize variables
    raise ArgumentError if (options[:x_size].nil? && options[:y_size].nil?)
    @x_size = options[:x_size]
    @y_size = options[:y_size]
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
    
    # $this->Picture = imagecreatetruecolor($XSize,$YSize);
    # 
    #  $C_White =$this->AllocateColor($this->Picture,255,255,255);
    #  imagefilledrectangle($this->Picture,0,0,$XSize,$YSize,$C_White);
    #  imagecolortransparent($this->Picture,$C_White);
    # 
    #  $this->setFontProperties("tahoma.ttf",8);
    
    
  end
  
  def draw_background(r, g, b)
    
  end
  
  def draw_rectangle(x1, y1, x2, y2, r, g, b)
    
  end
  
  def draw_filled_rectangle(x1, y1, x2, y2, r, g, b, draw_border=true, alpha=100)
    
  end

  def draw_rounded_rectangle(x1, y1, x2, y2, r, g, b)
    
  end
  
  def draw_filled_rounded_rectangle(x1, y1, x2, y2, r, g, b, draw_border=true, alpha=100)
    
  end

  def draw_circle(xc, yc, height, r, g, b, width)
    
  end
  
  def draw_filled_circle(xc, yc, height, r, g, b, width)
    
  end  
  
end