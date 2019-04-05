require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'
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
      station_create
    when 2
      train_create
    when 3
      route_create
    when 4
      route_edit
    when 5
      route_set_train
    when 6
      carriage_add
    when 7
      carriage_remove
    when 8
      train_move
    when 9
      list_stations_trains
    end
  end

  private

  def station_create
    system 'clear'
    print "Введите имя станции: "
    station_name = gets.chomp
    if station_name == ""
      puts "Имя станции не может быть пустым"
    else  
      stations << Station.new(station_name)
    end  
  end 

  def train_create
    system 'clear'
    puts "Выберите тип поезда: 1 - Пассажирский ; 2 - Грузовой"
    train_type = gets.to_i
    if train_type == 1
      puts "Введите номер поезда: "
      train_number = gets.to_i
      return puts "Номер поезда не может быть пустым" if (train_number == "" || train_number == 0)
      trains << PassengerTrain.new(train_number)
    elsif train_type == 2  
      puts "Введите номер поезда: "
      train_number = gets.to_i
      return puts "Номер поезда не может быть пустым" if (train_number == "" || train_number == 0)
      trains << CargoTrain.new(train_number)
    else
      puts "Неверный тип поезда"
    end
  end
  
  def route_create
    system 'clear'
    return puts "Создайте сначала две станции" if stations.size < 2
    puts "Выберите начальную станцию: "    
    stations.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end 
    start_station = stations[gets.to_i]
    return puts "Неверно выбрана станция" if !start_station 

    puts "Выберите конечную станцию: "
    remaining_stations = stations.select{ |station| station != start_station }
    remaining_stations.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end 
    end_station = remaining_stations[gets.to_i]
    return puts "Неверно выбрана станция" if !end_station
    routes << Route.new(start_station, end_station)
  end  

  def route_edit
    system 'clear'
    return puts "Нет маршрутов для просмотра" if routes.size < 1

    puts "Выберите маршрут для редактирования: "     
    choose_route
    @route_user = gets.to_i
    return puts "Неверно выбран маршрут" if !routes[@route_user]
    puts "1 - Добавить станцию; 2 - Удалить станцию"    
    user_choice = gets.to_i
    
    if user_choice == 1
      return puts "Нет промежуточных станций для добавления" if stations.size < 3
      route_edit_stations(1)
    elsif user_choice == 2  
      return puts "Нет промежуточных станций для удаления" if routes[@route_user].stations.size < 3
      route_edit_stations(2)
    else
      puts "Неверный выбор"
    end  
  end 

  def route_set_train
    system 'clear'
    return puts "Нет поездов для выбора" if trains.empty?
    puts "Выберите поезд,чтобы назначить маршрут: "
    choose_train
    train = trains[gets.to_i]
    return puts "Не выбран поезд" if !train 
    puts "Выберите маршрут для поезда: "
    return puts "Нет маршрутов для просмотра" if routes.size < 1
    choose_route
    route = routes[gets.to_i]
    return puts "Не выбран маршрут" if !route 
    train.add_route(route)
  end  
  
  def carriage_add
    system 'clear'
    return puts "Нет поездов для выбора" if trains.empty?
    puts "Выберите поезд,чтобы добавить вагон: "
    choose_train
    train = trains[gets.to_i]
    return puts "Не выбран поезд" if !train
    if train.type_of == :passenger
      carriage = CarriagePassenger.new
      train.add_carriage(carriage)
    elsif train.type_of == :cargo
      carriage = CargoCarriage.new
      train.add_carriage(carriage)
    end    
    puts "Вагон добавлен"
  end  

  def carriage_remove
    system 'clear'
    return puts "Нет поездов для выбора" if trains.empty?
    puts "Выберите поезд,чтобы удалить вагон: "
    choose_train
    train = trains[gets.to_i]
    return puts "Не выбран поезд" if !train
    train.remove_carriage
    puts "Вагон удален"
  end  

  def train_move
    system 'clear'
    return puts "Нет поездов для выбора" if trains.empty?
    puts "Выберите поезд для перемещения: "
    choose_train
    train = trains[gets.to_i]
    return puts "Не выбран поезд" if !train
    return puts "Нет маршрутов для просмотра" if routes.size < 1
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
    return puts "Нет станций для просмотра" if stations.size == 0
    puts "Выберите станцию для просмотра: "
    stations.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end  
    station = stations[gets.to_i]
    return puts "Не выбрана станция" if !station
    station.trains.each do |train|
      print "Номер: #{train.number}, Тип: #{train.type_of}, Вагоны: #{train.carriages} \n" 
    end
  end  

  def route_edit_stations(choose) 
    stations_exclude = [routes[@route_user].stations.first, routes[@route_user].stations.last]
    middle_stations = stations - stations_exclude
    middle_stations.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end  
    user_station = middle_stations[gets.to_i]
    return puts "Неверно выбрана станция" if !user_station
    
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
end  

start = Main.new
loop do
  start.actions
  user_choice = gets.to_i
  start.exec_actions(user_choice)
end  


