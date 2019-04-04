module Manufacturer
  attr_accessor :manufacturer

  def set_manufacturer
    puts "Введите производителя: "
    self.manufacturer = gets.chomp
  end
end
