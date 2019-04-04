class Route
  include InstanceCounter  

  attr_reader :start_station, :end_station, :stations

  def initialize(start_station, end_station)
    @stations = []
    @start_station = start_station
    @end_station = end_station
    @stations << @start_station << @end_station
    register_instance
  end 

  def add_station(station)
    @stations.insert(-2,station)
  end  

  def remove_station(station)
    @stations.delete(station) if station != (@start_station || @end_station)
  end   
end 

