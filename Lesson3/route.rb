class Route
  attr_accessor :stations

  def initialize(start_station, end_station)
    @stations = []
    @stations << start_station << end_station
  end  

  def add_station(station)
    @stations.insert(-2, station)
  end  

  def remove_station
    @stations.delete_at(-2)
  end 

  def show_stations
    @stations.each { |station| puts station.name }
  end
end 

