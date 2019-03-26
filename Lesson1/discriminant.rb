print "Введите коэффициент а = "
a = gets.to_f

print "Введите коэффициент b = "
b = gets.to_f

print "Введите коэффициент c = "
c = gets.to_f

d = b**2 - (4 * a * c)

if d < 0
  puts "Корней нет"
elsif d == 0
  x1 = -b / (2 * a) 
  puts "Дискриминант = #{d}, корень x1 = #{x1}"
elsif d > 0
  root_x = Math.sqrt(d)/(2**a)
  x1 = -b + root_x
  x2 = -b - root_x
  puts "Дискриминант = #{d}, корень x1 = #{x1}, корень x2 = #{x2}"
end
