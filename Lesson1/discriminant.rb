print "Введите коэффициент а = "
a = gets.chomp.to_f

print "Введите коэффициент b = "
b = gets.chomp.to_f

print "Введите коэффициент c = "
c = gets.chomp.to_f

d = b ** 2 - (4 * a * c)

if d < 0
  puts "Корней нет"
elsif d == 0
  x1 = -b / (2 * a) 
  puts "Дискриминант = #{d}, корень x1 = #{x1}"
elsif d > 0
  x1 = (-b + Math.sqrt(d))/(2 ** a) 
  x2 = (-b - Math.sqrt(d))/(2 ** a) 
  puts "Дискриминант = #{d}, корень x1 = #{x1}, корень x2 = #{x2}"
end