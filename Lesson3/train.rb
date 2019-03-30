class Train
  attr_reader :type_of, :number,  :carriages, :speed, :route, :current_station

  def initialize(number, type_of, carriages)
    @number = number
    @type_of = type_of
    @carriages = carriages
    @speed = 0
    @current_station_index 
  end  

  def up_speed(new_speed)
    @speed += new_speed if new_speed >= 0
  end 
  
  def low_speed(new_speed)
    (@speed -= new_speed) unless new_speed > @speed
  end  
 
  def stop
    @speed = 0
  end 

  def add_carriage
    stop
    @carriages += 1
  end 
  
  def remove_carriage
    stop
    @carriages -= 1
  end  

  def add_route(route_new)
    @route = route_new
    @current_station = @route.start_station
  end 

  def move_next_station
    return if (@current_station == @route.end_station)
    @current_station_index = @route.stations.index(@current_station) +1
    change_current_station
  end  

  def move_previous_station
    return if (@current_station == @route.start_station)
    @current_station_index = @route.stations.index(@current_station) - 1
    change_current_station
  end  

  def show_next_station
    @route.stations[@current_station_index + 1]
  end 

  def show_previous_station
    @route.stations[@current_station_index - 1]
  end 
  
  private

  def change_current_station
    @current_station = @route.stations[@current_station_index]
  end
end 
  