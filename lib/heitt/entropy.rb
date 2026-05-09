import math, tables


#this  code is a copy or inspiration of "https://github.com/chrisjchandler/entropy/blob/main/entropy.go"
def calculate_entropy(input)
  frequency = Hash.new(0)
  #count the frequency of each char
  input.each_char do |ch|
    frequency[ch] += 1
  end

  #calculate the total number of characters
  total = input.length.to_f
  #caluclate entropy
  entroph = 0.0
  frequency.each_value do |count|
    probability = count.to_f / total
    entropy += probability * Math.log2(probability)
  end
  #negate the sum as entropy is positive
  -entropy
end

def minimun_entropy(input, min_ent)
  calculate_entropy(input) >= min_ent
end