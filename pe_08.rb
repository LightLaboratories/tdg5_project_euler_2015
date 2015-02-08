# Project Euler #8 - Largest product in a series
# https://projecteuler.net/problem=8
#
# Find the thirteen adjacent digits in the 1000-digit number that have the
# greatest product. What is the value of this product?

def largest_product_in_series(series, adjacency_length = 13)
  zero_ord = '0'.ord
  factors = []
  largest_product = 0
  current_product = 1
  index = -1
  loop do
    while factors.length < adjacency_length
      new_factor = series[index += 1]
      # This assumes we can trust our input will only contain digits. If we can
      # safely assume this, calling String#ord and then subtracting the ordinal
      # of the string '0' will work faster than String#to_i.
      new_factor = new_factor.ord - zero_ord
      if new_factor.zero?
        # If our new_factor is zero, we know that the product of anything
        # currently in our collection of factors will be zero. So, rather than
        # work through that, just drop the current set of factors, drop the
        # zero, and reset our current product.
        factors.clear
        current_product = 1
      else
        factors << new_factor
        current_product *= new_factor
      end
    end
    largest_product = current_product if current_product > largest_product
    current_product /= factors.shift
  end
rescue NoMethodError
  # This rescue is used to efficiently detect whether we have reached the end of
  # the given series. Since String#[] will return nil once we've reached the end
  # of the series, the call to String#ord will fail because nil does not respond
  # to #ord. This will cause a NoMethodError to be raised which we then use as a
  # signal to return the calculated product. This approach, though confusing,
  # allows us to avoid comparing the current index to the length of the series
  # every iteration of the factor determination loop.
  raise unless index == series.length
  return largest_product
end

number = "7316717653133062491922511967442657474235534919493496983520312774506326239578318016984801869478851843858615607891129494954595017379583319528532088055111254069874715852386305071569329096329522744304355766896648950445244523161731856403098711121722383113622298934233803081353362766142828064444866452387493035890729629049156044077239071381051585930796086670172427121883998797908792274921901699720888093776657273330010533678812202354218097512545405947522435258490771167055601360483958644670632441572215539753697817977846174064955149290862569321978468622482839722413756570560574902614079729686524145351004748216637048440319989000889524345065854122758866688116427171479924442928230863465674813919123162824586178664583591245665294765456828489128831426076900422421902267105562632111110937054421750694165896040807198403850962455444362981230987879927244284909188845801561660979191338754992005240636899125607176060588611646710940507754100225698315520005593572972571636269561882670428252483600823257530420752963450"
puts largest_product_in_series(number)
