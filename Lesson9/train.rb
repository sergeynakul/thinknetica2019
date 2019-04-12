class Train
  include Manufacturer
  include InstanceCounter
  include Validation 

  TRAIN_NUMBER_FORMAT = /^(\d{3}|\w{3}-?)(\d{2}|\w{2})$/i.freeze  

  attr_reader :carriages, :speed, :route, :current_station, :type_of
  attr_accessor :number 

  @trains = {}

  class << self
    attr_accessor :trains

    def find(train_number)
      @trains[train_number]
    end
  end

  def initialize(number)
    @number = number.to_s
    @speed = 0
    @carriages = []
    self.class.trains[number] = self
    register_instance   
    validate!
  end

  def all_carriages
    @carriages.each_with_index { |carriage, index| yield(carriage, index) }
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

  def add_route(route_new)имя 
    @route = route_new
    @current_station_index = 0
    change_current_station
  end

  def add_carriage(carriage)
    stop
    @carriages << carriage if type_of == carriage.type_of
  end

  def remove_carriage
    stop
    @carriages.pop
  end

  def move_next_station
    return if @current_station == @route.end_station

    @current_station_index += 1
    change_current_station
  end

  def move_previous_station
    return if @current_station == @route.start_station

    @current_station_index -= 1
    change_current_station
  end

  def show_next_station
    return if @current_station == @route.end_station

    @route.stations[@current_station_index + 1]
  end

  def show_previous_station
    return if @current_station == @route.start_station

    @route.stations[@current_station_index - 1]
  end

  private

  def change_current_station
    @current_station.send_train(self) if @current_station
    @current_station = @route.stations[@current_station_index]
    @current_station.take_train(self)
  end

  def validate!
    raise 'Номер не должнен быть пустым' if @number == ''
    raise 'Неверный формат номера' if @number !~ TRAIN_NUMBER_FORMAT

    true
  end
end
