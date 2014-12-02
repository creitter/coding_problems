# Given an array of sorted integers (a), and an integer to seek (s), and a number
#  of integers to return (n), return an array of the n integers closest to s (in value)
#  integers from a.
# 
#  Example:
#   a = [ 2, 5, 10, 11, 12, 14, 18, 30 ]
#   s = 15
#   n = 4
# 
#  Return: [ 11, 12, 14, 18 ]
 
 def find_closest(a, s, n)
   results = []
   a.each { |number|
     if results.length < n
       results << number
     else
       if number <= s 
         if (s - number) < (s-results[0]) 
           results = results.drop(1)
           results << number
         else
         end
       else
         if (number - s) < (s-results[0])
           results = results.drop(1)
          results << number
         elsif (number-s) < s-results[n-1]
           delete_at(n-1)
           results << number
         end
       end
     end
   }
   results
   
 end
 
 find_closest([ 2, 5, 10, 11, 12, 14, 18, 30 ], 15, 4)
 
