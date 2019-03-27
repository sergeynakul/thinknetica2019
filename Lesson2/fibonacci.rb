arr = []

n = 1
m = 2

while n < 100
  arr << n
  n, m = m, n+m
end

