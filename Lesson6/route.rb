class Route
  include InstanceCounter
  include Valid

  attr_reader :start_station, :end_station, :stations

  def initialize(start_station, end_station)
    @stations = []
    @start_station = start_station
    @end_station = end_station    
    @stations << @start_station << @end_station
    register_instance
    validate!
  end 

  def add_station(station)
    @stations.insert(-2,station)
  end  

  def remove_station(station)
    @stations.delete(station) if station != (@start_station || @end_station)
  end   

  private 

  def validate!
    raise "Начальная станция не может быть конечной" if (@start_station == @end_station)
    true
  end 
end 

