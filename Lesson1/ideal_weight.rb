puts "Введите ваше имя"
name = gets.capitalize.chomp

puts "Введите ваш рост"
height = gets.chomp.to_i

ideal_weight = height - 110

if ideal_weight < 0
  puts "#{name}, ваш вес уже оптимальный"
else
  puts "#{name}, ваш идеальный вес #{ideal_weight} кг"
end  