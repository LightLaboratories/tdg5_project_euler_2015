#  https://projecteuler.net/problem=77
#
#  It is possible to write ten as the sum of primes in exactly five different ways:
#
#  7 + 3
#  5 + 5
#  5 + 3 + 2
#  3 + 3 + 2 + 2
#  2 + 2 + 2 + 2 + 2
#
#  What is the first value which can be written as the sum of primes in over five thousand different ways?

class PrimeFinder
  attr_reader :limit, :primes

  def initialize(limit)
    @limit = limit
    @primes = []
    generate_primes!(limit)
  end

  def prime?(candidate)
    sqr_root = Math.sqrt(candidate)
    primes.each do |prime|
      return false if candidate % prime == 0
      break if prime > sqr_root
    end
    true
  end

  def inspect
    "#<PrimeFinder:#{object_id}>"
  end

  private

  def generate_primes!(limit)
    primes.clear
    sieve = [true] * limit
    sieve[0] = sieve[1] = false
    (2..limit).each do |candidate|
      is_candidate_prime = sieve[candidate]
      next unless is_candidate_prime

      primes << candidate
      candidate.step(limit, candidate) do |composite|
        sieve[composite] = false
      end
    end
  end
end

class PrimeSumLookup
  def initialize(limit)
    @primes = PrimeFinder.new(limit).primes
    @prime_sums = {}
  end

  def prime_sums(num)
    @prime_sums[num] ||= calculate_prime_sums(num)
  end

  private

  attr_reader :primes

  def calculate_prime_sums(num)
    sums = []
    primes.each do |prime|
      prime_addend = num - prime
      break if prime_addend < 0

      prime_addend_sums = prime_sums(prime_addend)
      if primes.include?(prime_addend)
        prime_addend_sums << [prime_addend]
      else
        next if prime_addend_sums.length.zero?
      end

      prime_addend_sums.each do |sum|
        new_sum = [prime].concat(sum)
        sums << new_sum.sort!
      end
    end
    sums.sort!
    sums.uniq!
    sums
  end
end

sums = PrimeSumLookup.new(5000)
index = 0
index += 1 while sums.prime_sums(index).length <= 5000
puts index
