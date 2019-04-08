class Station
  include InstanceCounter  
  include Valid

  attr_reader :name, :trains

  @@stations = []

  def initialize(name)
    @name = name
    validate!
    @trains = []
    @@stations << self
    register_instance
  end 

  def self.all
    @@stations 
  end

  def all_trains
    @trains.each { |train| yield train }
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

  private

  def validate!
    raise "Имя не может быть пустым" if (@name == "")
    true
  end  
end

