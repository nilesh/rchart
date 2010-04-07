require 'rubygems'
require 'ruby-debug'
require 'gd2'
class RData
  
  def initialize
    @data                          = []
    @data_description              = {}
    @data_description["position"]  = "name"
    @data_description["format"]    = {"x"=>"number"}
    @data_description["format"]    = {"y" => "number"}
    @data_description["unit"]      = {"x" => ""}
    @data_description["unit"]      = {"y"=>  ""}
 end

  def add_point(value,serie="Serie1",description="")
    if ((value.is_a?(Array)) && value.count == 1)
      value = value[0]
    end  
    id = 0      
   
    @data.each_with_index do |v,index|
      id = index+1  unless @data[index][serie].nil?
    end
    if (value.count == 1 )
      @data[id][serie] = value
      if description != "" 
        @data[id]["name"] = description;
      elsif @data[id]["name"].nil?
        @data[id]["name"] = id
      end  
    else
        
      value.each do |k| 
        if @data[id].nil?
          @data[id] = {serie=>k}#TODO check k
        else
          @data[id] = @data[id].merge({serie=>k})
        end
         
        @data[id]["name"] = id  if @data[id]["name"].nil?
        id = id+1
      end
  
    end
    
  end 
  def add_serie(serie_name="Serie1")
    if (@data_description["values"].nil?)
      @data_description["values"]= serie_name
    else
      found = false
       @data_description["values"].each do |k| 
        found = true if ( k == serie_name )  #TODO check
       end 
        @data_description["values"] = serie_name if (found )
    end
    
  end
  def add_all_series
     @data_description["values"] = []
    if(!@data[0].nil?)
      @data[0].each do |k,v| 
        if (k != "name" )
          @data_description["values"].push(k)
        end
      end
    end
  end
  def remove_serie(serie_name="Serie1")
    if (!@data_description["values"].nil?)
       found = false;
       @data_description["values"].each do |v|
         @data_description["values"].delete(v)  if (v == serie_name )
      end
    end   
  end
 def set_abscise_label_serie(serie_name = "Name")
   @data_description["position"] = serie_name
 end

 def set_serie_name(name,serie_name="Serie1")
  if @data_description["description"].nil?
   @data_description["description"]={serie_name => name}
  else
     @data_description["description"] = @data_description["description"].merge(serie_name => name)
  end 
 end   

 def set_x_axis_name(name="X Axis")
   @data_description["axis"]={"x" => name}
 end
 
 def set_y_axis_name(name="Y Axis")
    @data_description["axis"]= {"y" => name}
 end

 def set_x_axis_format(format="number")
   @data_description["format"]["x"] = format
 end

 def set_y_axis_format(format="number")
   @data_description["format"]["y"] = format
 end
  
 def set_x_axis_unit(unit="")
   @data_description["unit"]["x"] = unit
 end

 def set_y_axis_unit(unit="")
    @data_description["unit"]["y"] = unit
 end

 def set_serie_symbol(name,symbol)
   @data_description["symbol"][name] = symbol
 end
 
 def remove_serie_name(serie_name)
   if(!@data_description["description"][serie_name].nil?)
      @data_description["description"].delete(serie_name)
   end 
 end
 def remove_all_series
   @data_description["values"].each do |v|
     @data_description["values"].delete(v)
   end 
 end
 
 def get_data
    @data
 end  
 def get_data_description
    @data_description
 end
 
end
