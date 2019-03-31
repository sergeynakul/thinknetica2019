class Station
  attr_reader :name, :trais

  def initialize(name)
    @name = name
    @trains = []
  end 

  def take_train(train)
    @trains << train
  end 

  def trains_type(type)
    @trains.select  { |train| train.type_of if train.type_of == type }
  end  

  def send_train(train)
    @trains.delete(train)
  end  
end

