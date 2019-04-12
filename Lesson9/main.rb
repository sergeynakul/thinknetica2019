require_relative 'manufacturer.rb'
require_relative 'instance_counter.rb'
require_relative 'validation.rb'
require_relative 'train.rb'
require_relative 'route.rb'
require_relative 'station.rb'
require_relative 'cargo_train.rb'
require_relative 'carriage_cargo.rb'
require_relative 'passenger_train.rb'
require_relative 'carriage_passenger.rb'

puts 'Интерфейс управление железнодородной станцией'

class Main
  attr_reader :stations, :routes, :trains

  TRAIN_TYPE = { 1 => :passenger, 2 => :cargo }.freeze

  def initialize
    @stations = []
    @routes = []
    @trains = []
  end

  def actions
    actions = [
      '1. Создать станцию', '2. Создать поезд', '3. Создать маршрут',
      '4. Редактирование маршрута', '5. Выбрать маршрут для поезда',
      '6. Добавить вагон', '7. Отцепить вагон', '8. Переместить поезд по маршруту',
      '9. Список станций и поездов на них', '0. Выход'
    ]
    actions.each { |action| puts action }
  end

  def exec_actions(action)
    options = {
      0 => :exit, 1 => :station_create, 2 => :train_create, 3 => :route_create,
      4 => :route_edit, 5 => :route_set_train, 6 => :carriage_add,
      7 => :carriage_remove, 8 => :train_move, 9 => :list_stations_trains
    }
    system 'clear'
    call_action(options[action])
  end

  private

  def call_action(method)
    send(method)
  rescue RuntimeError => e
    puts e.inspect
  end

  def station_create
    print 'Введите имя станции: '
    station_name = gets.chomp
    stations << Station.new(station_name)
    puts "Создана станция с именем: #{station_name}"
  end

  def train_create
    puts 'Выберите тип поезда: 1 - Пассажирский; 2 - Грузовой '
    type = gets.to_i
    raise 'Неверный тип поезда' unless TRAIN_TYPE[type]

    puts 'Введите номер поезда: '
    train_number = gets.chomp
    trains << Object.const_get(TRAIN_TYPE[type].to_s.capitalize + 'Train').new(train_number)
    puts "Создан поезд с номером: #{train_number}"
  end

  def route_create
    raise 'Создайте сначала две станции' if stations.size < 2

    puts 'Выберите начальную станцию: '
    stations.each_with_index { |station, index| puts "#{index}: #{station.name}" }
    start_station = stations[gets.to_i]
    raise 'Неверно выбрана станция' unless start_station

    puts 'Выберите конечную станцию: '
    remaining_stations = stations.reject { |station| station == start_station }
    remaining_stations.each_with_index { |station, index| puts "#{index}: #{station.name}" }
    end_station = remaining_stations[gets.to_i]
    raise 'Неверно выбрана станция' unless end_station

    routes << Route.new(start_station, end_station)
  end

  def route_edit
    raise 'Нет маршрутов для просмотра' if routes.empty?

    puts 'Выберите маршрут для редактирования: '
    choose_route
    @route_user = gets.to_i
    raise 'Неверно выбран маршрут' unless routes[@route_user]

    puts '1 - Добавить станцию; 2 - Удалить станцию'
    user_choice = gets.to_i

    if user_choice == 1
      raise 'Нет промежуточных станций для добавления' if stations.size < 3

      route_edit_stations(1)
    elsif user_choice == 2
      raise 'Нет промежуточных станций для удаления' if routes[@route_user].stations.size < 3

      route_edit_stations(2)
    else
      puts 'Неверный выбор'
    end
  end

  def route_set_train
    raise 'Нет поездов для выбора' if trains.empty?

    puts 'Выберите поезд,чтобы назначить маршрут: '
    choose_train
    train = trains[gets.to_i]
    raise 'Не выбран поезд' unless train

    puts 'Выберите маршрут для поезда: '
    raise 'Нет маршрутов для просмотра' if routes.empty?

    choose_route
    route = routes[gets.to_i]
    raise 'Не выбран маршрут' unless route

    train.add_route(route)
  end

  def carriage_add
    raise 'Нет поездов для выбора' if trains.empty?

    puts 'Выберите поезд,чтобы добавить вагон: '
    choose_train
    train = trains[gets.to_i]
    raise 'Не выбран поезд' unless train

    if train.type_of == :passenger
      puts 'Задайте количество мест в вагон: '
      seats = gets.to_i
      carriage = CarriagePassenger.new(seats)
      puts 'Занять место в вагоне?(y/n)'
      answer = gets.chomp.downcase
      if answer == 'y'
        carriage.engadged_seat && train.add_carriage(carriage)
      else
        train.add_carriage(carriage)
      end
    elsif train.type_of == :cargo
      puts 'Задайте общий объем вагона: '
      volume = gets.to_i
      carriage = CargoCarriage.new(volume)
      puts 'Сколько хотите занять объема для груза: '
      volume_reserved = gets.to_i
      carriage.engadged_volume(volume_reserved)
      train.add_carriage(carriage)
    end
    puts 'Вагон добавлен'
  end

  def carriage_remove
    raise 'Нет поездов для выбора' if trains.empty?

    puts 'Выберите поезд,чтобы удалить вагон: '
    choose_train
    train = trains[gets.to_i]
    raise 'Не выбран поезд' unless train

    train.remove_carriage
    puts 'Вагон удален'
  end

  def train_move
    raise'Нет поездов для выбора' if trains.empty?

    puts 'Выберите поезд для перемещения: '
    choose_train
    train = trains[gets.to_i]
    raise 'Не выбран поезд' unless train
    raise 'Нет маршрутов для просмотра' if routes.empty?

    puts "Поезд на станции: #{train.current_station.name}"
    puts 'Выберите куда поедет поезд: '
    puts '1: Вперед; 2: Назад'
    move = gets.to_i

    if move == 1
      train.move_next_station
      puts "Поезд на станции: #{train.current_station.name}"
    elsif move == 2
      train.move_previous_station
      puts "Поезд на станции: #{train.current_station.name}"
    else
      puts 'Неверный выбор'
    end
  end

  def list_stations_trains
    raise 'Нет станций для просмотра' if stations.empty?

    puts 'Выберите станцию для просмотра: '
    stations.each_with_index do |station, index|
      puts "#{index}: #{station.name}"
    end
    station = stations[gets.to_i]
    raise 'Не выбрана станция' unless station

    station.all_trains do |train|
      puts "№: #{train.number}, тип: #{train.type_of}, вагонов: #{train.carriages.size}"
      show_carriages(train)
    end
  end

  def route_edit_stations(choose)
    stations_exclude = [routes[@route_user].stations.first, routes[@route_user].stations.last]
    middle_stations = stations - stations_exclude
    middle_stations.each_with_index { |station, index| puts "#{index}: #{station.name}" }
    user_station = middle_stations[gets.to_i]
    raise 'Неверно выбрана станция' unless user_station

    if choose == 1
      routes[@route_user].add_station(user_station) unless routes[@route_user].stations.include?(user_station)
    elsif choose == 2
      routes[@route_user].remove_station(user_station) if routes[@route_user].stations.include?(user_station)
    end
  end

  def choose_route
    routes.each_with_index do |route, index|
      puts "#{index}:#{route.stations.first.name} -#{route.stations.last.name}"
    end
  end

  def choose_train
    trains.each_with_index do |train, index|
      puts "#{index}: #{train.number}"
    end
  end

  def show_carriages(train)
    train.all_carriages do |carriage, index|
      print "№: #{index}, тип: #{carriage.type_of}, "
      if train.type_of == :passenger
        print "свободных мест: #{carriage.free_seats},
                занятых: #{carriage.seats_busy} \n"
      elsif train.type_of == :cargo
        print "свободный объем: #{carriage.free_volume},
              занято: #{carriage.volume_busy} \n"
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
