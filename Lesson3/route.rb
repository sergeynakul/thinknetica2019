class Route
  attr_reader :start_station, :end_station,  :stations, :middle_stations

  def initialize(start_station, end_station)
    @stations = []
    @stations << start_station << end_station
    @middle_stations = []
    @start_station = start_station
    @end_station = end_station
  end  

  def add_station(station)
    @middle_stations << station
    @stations.insert(-2,middle_stations).flatten!
    @stations.uniq!
  end  

  def remove_station(station)
    if @middle_stations.include?(station)
      @middle_stations.delete(station)
      @stations.delete(station) 
    end
  end   
end 

