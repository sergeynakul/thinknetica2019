months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]

loop do 
  print "Введите год: "
  year = gets.to_i

  if (year % 4 == 0 && year % 100 != 0) || year % 400 == 0
    months[1] = 29
  end

  print "Введите месяц в цифрах(до 12): "
  month = gets.to_i

  print "Введите число месяца(до 31): "
  day_month = gets.to_i

  if day_month > months[month-1]
    puts "Число месяца введено неверно, попробуйте еще раз"
  elsif month == 1
    puts day_month
  else
    puts "Номер дня с начала года: #{months.take(month-1).inject(:+) + day_month}"
  end
end

