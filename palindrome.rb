# Write a function that takes an integer and returns the smallest number that is greater than the given number which is a palendrome.

def pal(number)
  if number.to_s == number.to_s.reverse
    number
  else
    left = number.slice(0,number.length/2)

    if number.length.odd?
      middle = number.slice(number.length/2)
      right = number.slice(number.length/2+1, number.length)
            
      if left.to_i > right.reverse.to_i
        right = left.reverse
      else
        if left.to_i <= right.to_i
          middle = middle.to_i + 1
        end
        
        right = left.reverse
      end
    else #even?
      middle = ""
      right = number.slice(number.length/2, number.length)
      
      if left.to_i >= right.reverse.to_i
        if left.to_i >= right.to_i
          left = (left.to_i + 1).to_s
        end
        right = left.reverse
      else
        if left.to_i < right.to_i
          left = (left.to_i + 1).to_s
        end

        right = left.reverse
      end
    end

    left.to_s + middle.to_s + right.to_s

  end
end


# NOT VALID YET


# Evens
pal("4141") # => 4224
pal("41") # => 44
pal("14") # => 22
pal("1414") # => 1441
pal("4140") # => 4224
pal("4041") # => 4114

# pal("") # =>
