alphabet = ('а'..'я'  )
vowels = %w(а о и е э ы у ю я).to_a

hash_vowels = {}

alphabet.each.with_index(1) do |letter, position|
  hash_vowels[letter] = position if vowels.include?(letter)
end  

