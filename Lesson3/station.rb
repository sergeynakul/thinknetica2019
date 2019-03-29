class Station
  attr_accessor :name

  def initialize(name)
    @name = name
    @trains = []
  end 

  def take_train(train)
    @trains << train
  end 

  def trains
    @trains.each { |train| puts train.number }
  end 
  
  def trains_type(type_of)
    @trains.each { |train| puts train.type_of}
  end  

  def send_train(train)
    @trains.delete(train)
  end  
end


