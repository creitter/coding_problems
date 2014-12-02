# Find a substring location within a longer string
# Case Sensitive
# First instance
# Substring is a single word no spaces.


def find_substring(sentence, word)
  longer = sentence.split("")
  shorter = word.split("")
  l_index = 0
  s_index = 0
  possible_start = -1
  
  while l_index < longer.length
    while s_index < shorter.length
      
      if longer[l_index + s_index] == shorter[s_index] 
        possible_start = l_index  if (possible_start == -1)
        s_index = s_index + 1
      else
        if s_index == 0
          l_index = l_index + 1
        else
          l_index = l_index + s_index
        end
        
        s_index = 0
        possible_start = -1
        break
      end
    end #while
    
    if s_index  == shorter.length
      break
    end
     
  end #while
  
  possible_start
end


find_substring("A Quick Brown Fox", "Brown")