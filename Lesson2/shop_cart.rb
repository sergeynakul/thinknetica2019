shop_cart = {}

loop do
  print "Введите название товара: "
  item = gets.chomp
  break if item == "стоп"

  print "Введите стоимость товара: "
  price = gets.to_f

  print "Введите кол-во купленного товара: "
  quantity = gets.to_f
  
  shop_cart[item] = { цена: price, количество: quantity, итого: price * quantity } 
end

total_price = shop_cart.sum{ |цена:, количество:, итого:| итого }

puts shop_cart
puts "Общая сумма покупок: #{total_price}"

