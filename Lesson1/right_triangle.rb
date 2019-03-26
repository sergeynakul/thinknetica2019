sides = [] 

print "Введите первую сторону треугольника: "
sides << gets.chomp.to_f

print "Введите вторую сторону  треугольника: "
sides << gets.chomp.to_f

print "Введите третью сторону треугольника: "
sides << gets.chomp.to_f

sorted_sides = sides.sort! 

if (sorted_sides[0] == sorted_sides[1]) && sorted_sides[0] == sorted_sides[2]
  puts "Треугольник не является прямоугольным, он равносторонний и равнобедренный!"
elsif sorted_sides[0] == sorted_sides[1]
  puts "Треугольник является равнобедеренным"
elsif sorted_sides[2]**2 == sorted_sides[0]**2 + sorted_sides[1] ** 2
  puts "Треугольник является прямоугольным"
else
  puts "Треугольник не является прямоугольным"
end
