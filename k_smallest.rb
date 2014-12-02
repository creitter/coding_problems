# Write a program to return the K smallest number from M sorted lists.

def k_smallest(sorted_list, k) 
  smallest = []
  sorted_list.each { |sub| 
    sub.each { | number |
      if smallest.empty? || smallest.length < k
        smallest << number
      elsif smallest.last > number 
        smallest[smallest.length-1] = number
      else smallest.last <= number
        break
      end
      smallest = smallest.sort
    }
  }
  smallest
end

k_smallest([ [1,3,4], [2,2,6], [3,5,8] ], 4) #will return [1,2,2,3] 
k_smallest([ [3,3,3,3], [1,1,1,1], [2,2,2,2] ], 3) #will return [1,1,1] 
k_smallest([ [1,1,99],[2,3,5,7],[2,2,2,3] ], 5) #will return [1,1,2,2,2]
