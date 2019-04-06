class Train
  include Manufacturer
  include InstanceCounter  
  include Valid

  attr_reader :carriages, :speed, :route, :current_station, :type_of
  attr_accessor :number

  TRAIN_NUMBER_FORMAT = /^(\d{3}|\w{3}-?)(\d{2}|\w{2})$/i

  @@trains = {}

  def initialize(number)
    @number = number
    @speed = 0
    @carriages = []
    @@trains[number] = self
    register_instance
    validate!
  end  

  def self.find(train_number)
    @@trains[train_number]
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

  def add_route(route_new)
    @route = route_new
    @current_station_index = 0
    change_current_station
  end 

  def add_carriage(carriage)
    stop
    @carriages << carriage if (self.type_of == carriage.type_of)
  end 
    
  def remove_carriage
    stop
    @carriages.pop
  end 

  def move_next_station
    return if (@current_station == @route.end_station)
    @current_station_index += 1
    change_current_station
  end  

  def move_previous_station
    return if (@current_station == @route.start_station)
    @current_station_index -= 1
    change_current_station
  end  

  def show_next_station
    return if (@current_station == @route.end_station)
    @route.stations[@current_station_index + 1]
  end 

  def show_previous_station
    return if (@current_station == @route.start_station)
    @route.stations[@current_station_index - 1]
  end 
  
  private

  def change_current_station
    @current_station.send_train(self) if @current_station 
    @current_station = @route.stations[@current_station_index]
    @current_station.take_train(self) 
  end 

  def validate!
    raise "Номер не должнен быть пустым" if (@number == "" || @number == 0)
    raise "Неверный формат номера" if (@number !~ TRAIN_NUMBER_FORMAT)
    true
  end  
end 
  