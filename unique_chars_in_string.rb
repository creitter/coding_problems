# Implement a function to determine if a string has all unique characters.
# What if you cannot use another data structure?
# Assumption: only alphabetic characters a-z/A-Z, not case sensitive

def unique_characters(my_string)
  my_hash = {}
  results = true
  my_string.split("").each { |ch|
    ch = ch.downcase
    if my_hash[ch].nil?
      my_hash[ch] = true
    else
      results = false
      break
    end
  }
  results
end


def unique_characters_array_only(my_string)
  alphabet = Array.new(25)
  results = true
  my_string = my_string.upcase
  my_string.each_byte { |ch|
    if alphabet[ch-65].nil?
      alphabet[ch-65] = true
    else
      results = false
      break
    end
  }
  results
end
