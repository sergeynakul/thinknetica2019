require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'
require_relative 'valid.rb'
require_relative 'train.rb'
require_relative 'route.rb'
require_relative 'station.rb'
require_relative 'cargo_train.rb'
require_relative 'carriage_cargo.rb'
require_relative 'passenger_train.rb'
require_relative 'carriage_passenger.rb'

puts "Интерфейс управление железнодородной станцией"

class Main
  attr_reader :stations, :routes, :trains

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end  

  def actions
    puts
    puts "1. Создать станцию"
    puts "2. Создать поезд"
    puts "3. Создать маршрут"
    puts "4. Редактирование маршрута"
    puts "5. Выбрать маршрут для поезда"
    puts "6. Добавить вагон"
    puts "7. Отцепить вагон"
    puts "8. Переместить поезд по маршруту"
    puts "9. Список станций и поездов на них"
    puts "0. Выход"
  end

  def exec_actions(action)
    case action
    when 0
      exit
    when 1
      call_action(:station_create)
    when 2
      call_action(:train_create)
    when 3
      call_action(:route_create)
    when 4
      call_action(:route_edit)
    when 5
      call_action(:route_set_train)
    when 6
      call_action(:carriage_add)
    when 7
      call_action(:carriage_remove)
    when 8
      call_action(:train_move)
    when 9
      call_action(:list_stations_trains)
    end
  end

  private

  def call_action(method)
    self.send(method)
  rescue RuntimeError => e
    puts e.inspect
  end

  def station_create
    system 'clear'
    print "Введите имя станции: "
    station_name = gets.chomp
    stations << Station.new(station_name)
    puts "Создана станция с именем: #{station_name}"
  end 

  def train_create
    system 'clear'
    puts "Выберите тип поезда: 1 - Пассажирский ; 2 - Грузовой"
    train_type = gets.to_i
    if train_type == 1
      puts "Введите номер поезда: "
      train_number = gets.chomp
      trains << PassengerTrain.new(train_number)
      puts "Cоздан поезд с номером: #{train_number}"
    elsif train_type == 2  
      puts "Введите номер поезда: "
      train_number = gets.chomp
      trains << CargoTrain.new(train_number)
      puts "Поезд создан с номером: #{train_number}"
    else
      raise "Неверный тип поезда"
    end
  end
  
  def route_create
    system 'clear'
    raise "Создайте сначала две станции" if stations.size < 2
    puts "Выберите начальную станцию: "    
    stations.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end 
    start_station = stations[gets.to_i]
    raise "Неверно выбрана станция" if !start_station 

    puts "Выберите конечную станцию: "
    remaining_stations = stations.select{ |station| station != start_station }
    remaining_stations.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end 
    end_station = remaining_stations[gets.to_i]
    raise "Неверно выбрана станция" if !end_station
    routes << Route.new(start_station, end_station)
  end  

  def route_edit
    system 'clear'
    raise "Нет маршрутов для просмотра" if routes.size < 1

    puts "Выберите маршрут для редактирования: "     
    choose_route
    @route_user = gets.to_i
    raise "Неверно выбран маршрут" if !routes[@route_user]
    puts "1 - Добавить станцию; 2 - Удалить станцию"    
    user_choice = gets.to_i
    
    if user_choice == 1
      raise "Нет промежуточных станций для добавления" if stations.size < 3
      route_edit_stations(1)
    elsif user_choice == 2  
      raise "Нет промежуточных станций для удаления" if routes[@route_user].stations.size < 3
      route_edit_stations(2)
    else
      puts "Неверный выбор"
    end  
  end 

  def route_set_train
    system 'clear'
    raise "Нет поездов для выбора" if trains.empty?
    puts "Выберите поезд,чтобы назначить маршрут: "
    choose_train
    train = trains[gets.to_i]
    raise "Не выбран поезд" if !train 
    puts "Выберите маршрут для поезда: "
    raise "Нет маршрутов для просмотра" if routes.size < 1
    choose_route
    route = routes[gets.to_i]
    raise "Не выбран маршрут" if !route 
    train.add_route(route)
  end  
  
  def carriage_add
    system 'clear'
    raise "Нет поездов для выбора" if trains.empty?
    puts "Выберите поезд,чтобы добавить вагон: "
    choose_train
    train = trains[gets.to_i]
    raise "Не выбран поезд" if !train
    if train.type_of == :passenger
      puts "Задайте количество мест в вагон: "
      seats = gets.to_i
      carriage = CarriagePassenger.new(seats)
      puts "Занять место в вагоне?(y/n)"
      answer = gets.chomp.downcase 
      if answer == 'y'
        carriage.engadged_seat
        train.add_carriage(carriage)
      else
        train.add_carriage(carriage)
      end      
    elsif train.type_of == :cargo
      puts "Задайте общий объем вагона: "
      volume = gets.to_i
      carriage = CargoCarriage.new(volume)
      puts "Сколько хотите занять объема для груза: "
      volume_reserved = gets.to_i
      carriage.engadged_volume(volume_reserved)
      train.add_carriage(carriage)
    end    
    puts "Вагон добавлен"
  end  

  def carriage_remove
    system 'clear'
    raise "Нет поездов для выбора" if trains.empty?
    puts "Выберите поезд,чтобы удалить вагон: "
    choose_train
    train = trains[gets.to_i]
    raise "Не выбран поезд" if !train
    train.remove_carriage
    puts "Вагон удален"
  end  

  def train_move
    system 'clear'
    raise"Нет поездов для выбора" if trains.empty?
    puts "Выберите поезд для перемещения: "
    choose_train
    train = trains[gets.to_i]
    raise "Не выбран поезд" if !train
    raise "Нет маршрутов для просмотра" if routes.size < 1
    puts "Поезд на станции: #{train.current_station.name}"
    puts "Выберите куда поедет поезд: "
    puts "1: Вперед; 2: Назад"
    move = gets.to_i

    if move == 1 
      train.move_next_station
      puts "Поезд на станции: #{train.current_station.name}"
    elsif move == 2
      train.move_previous_station
      puts "Поезд на станции: #{train.current_station.name}"
    else
      puts "Неверный выбор"
    end   
  end  

  def list_stations_trains
    system 'clear'
    raise "Нет станций для просмотра" if stations.size == 0
    puts "Выберите станцию для просмотра: "
    stations.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end  
    station = stations[gets.to_i]
    raise"Не выбрана станция" if !station
    station.all_trains do |train|
      puts "№: #{train.number}, тип: #{train.type_of}, вагонов: #{train.carriages.size}"
      show_carriages(train)
    end
  end  

  def route_edit_stations(choose) 
    stations_exclude = [routes[@route_user].stations.first, routes[@route_user].stations.last]
    middle_stations = stations - stations_exclude
    middle_stations.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end  
    user_station = middle_stations[gets.to_i]
    raise "Неверно выбрана станция" if !user_station
    
    if choose == 1      
      routes[@route_user].add_station(user_station) unless routes[@route_user].stations.include?(user_station)
    elsif choose == 2       
      routes[@route_user].remove_station(user_station) if routes[@route_user].stations.include?(user_station)
    end     
  end  

  def choose_route
    routes.each_with_index do |route, index|
      puts "#{index}: #{route.stations.first.name} --- #{route.stations.last.name}"
    end  
  end  

  def choose_train
    trains.each_with_index do |train, index| 
      puts "#{index}: #{train.number}"
    end 
  end 
  
  def show_carriages(train)
    if train.type_of == :passenger
      train.all_carriages do |carriage, index|
        puts "№: #{index}, 
        тип: #{carriage.type_of}, 
        свободных мест: #{carriage.free_seats}, 
        занятых: #{carriage.seats_busy}"
      end
    elsif train.type_of == :cargo  
      train.all_carriages do |carriage, index|
        puts "№: #{index}, 
        тип: #{carriage.type_of}, 
        свободный объем: #{carriage.free_volume}, 
        занято: #{carriage.volume_busy}"
      end
    end
  end
end  

start = Main.new
loop do
  start.actions
  user_choice = gets.to_i
  start.exec_actions(user_choice)
end  


