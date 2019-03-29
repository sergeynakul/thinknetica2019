class Train
  attr_accessor :speed, :route, :current_station, :carriages
  attr_reader :type_of, :number

  def initialize(number, type_of, carriages)
    @number = number
    @type_of = type_of
    @carriages = carriages
    @speed = 0
    @route = nil
    @current_station = nil
  end  

  def up_speed(speed)
    self.speed = speed
  end 
  
  def slow_speed(speed)
    self.speed(speed)
  end  
 
  def stop
    self.speed = 0
  end 

  def add_carriage
    stop
    self.carriages += 1
  end 
  
  def remove_carriage
    stop
    self.carriages -= 1
  end  

  def add_route(route)
    self.route = route
    self.current_station = self.route.stations.first 
  end 

  def move_next_station
    self.current_station = self.route.stations.index(self.current_station) + 1
    add_current_station
  end  

  def move_previous_station
    self.current_station = self.route.stations.index(self.current_station) - 1
    add_current_station
  end  

  def show_next_station
    next_station = self.route.stations.index(self.current_station) + 1
    puts "Следующая станция: #{self.route.stations[next_station].name}"
  end 

  def show_previous_station
    previous_station = self.route.stations.index(self.current_station) - 1
    puts "Предыдущая станция: #{self.route.stations[previous_station.name]}"
  end 
  
  private

  def add_current_station
    self.current_station = self.route.stations[self.current_station]
  end
end 


