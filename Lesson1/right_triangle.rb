sides = [] 

print "Введите первую сторону треугольника: "
sides << gets.to_f

print "Введите вторую сторону  треугольника: "
sides << gets.to_f

print "Введите третью сторону треугольника: "
sides << gets.to_f

a, b, c = sides.sort

if (a == b) && a == c
  puts "Треугольник не является прямоугольным, он равносторонний и равнобедренный!"
elsif a == b
  puts "Треугольник является равнобедеренным"
elsif c**2 == a**2 + b**2
  puts "Треугольник является прямоугольным"
else
  puts "Треугольник не является прямоугольным"
end
