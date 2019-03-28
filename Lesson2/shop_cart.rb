shop_cart = {}

loop do
  print "Введите название товара: "
  item = gets.chomp
  break if item == "стоп"

  print "Введите стоимость товара: "
  price = gets.to_f

  print "Введите кол-во купленного товара: "
  quantity = gets.to_f
  
  shop_cart[item] = { price: price, quantity: quantity, amount: price * quantity } 
end

total_price = shop_cart.sum{ |price:, quantity:, amount:| amount }

puts shop_cart
puts "Общая сумма покупок: #{total_price}"

