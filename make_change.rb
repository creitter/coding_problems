# Write a program which takes as input cents and returns the change returned using the largest coins first
def make_change(cents)
  output = []
  cents = cents.to_i
  [25,10,5,1].each do |x|
    break if cents == 0
    y = cents / x
    output.push({x => y})
   cents = cents - (x*y)
  end
  output
end

make_change(205) #=> [{25=>8}, {10=>0}, {5=>1}] 