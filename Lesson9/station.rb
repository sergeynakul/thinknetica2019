class Station
  include InstanceCounter
  include Validation  

  attr_reader :name, :trains

  validate :name, :presence

  @stations = []

  class << self
    attr_reader :stations

    def all
      @stations
    end
  end

  def initialize(name)
    @name = name
    validate!
    @trains = []
    self.class.stations << self
    register_instance
  end

  def all_trains
    @trains.each { |train| yield train }
  end

  def take_train(train)
    @trains << train
  end

  def trains_type(type)
    @trains.select { |train| train.type_of if train.type_of == type }
  end

  def send_train(train)
    @trains.delete(train)
  end
end
