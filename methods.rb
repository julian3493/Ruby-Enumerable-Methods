# rubocop:disable Metrics/ModuleLength
# rubocop:disable Metrics/CyclomaticComplexity
# rubocop:disable Metrics/PerceivedComplexity
# rubocop:disable Style/RedundantSelf

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    list = to_a if self.class == Range || Hash

    i = 0
    while i < list.length
      yield(list[i])
      i += 1
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    list = to_a if self.class == Range || Hash

    i = 0
    while i < list.length
      yield(list[i], i)
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    sel_arr = []
    my_each { |item| sel_arr.push(item) if yield(item) }
    sel_arr
  end

  def my_all?(arg = nil)
    if block_given?
      my_each { |item| return false if yield(item) == false }
      true
    elsif arg.nil?
      my_each { |item| return false if item.nil? }
    elsif !arg.nil? and arg.is_a?(Class)
      my_each { |item| return false unless [item.class.superclass].include?(arg) }
    elsif arg.class == Regexp
      my_each { |item| return false unless arg.match(item) }
    else my_each { |item| return false if item != arg }
    end
    true
  end

  def my_any?(arg = nil)
    if block_given?
      my_each { |item| return true if yield(item) }
    elsif arg.nil?
      my_each { |item| return true if item }
    elsif !arg.nil? and arg.is_a?(Class)
      my_each { |item| return true if [item.class, item.class.superclass].include?(arg) }
    elsif arg.class == Regexp
      my_each { |item| return true if arg.match(item) }
    else my_each { |item| return true if item == arg }
    end
    false
  end

  def my_none?(arg = nil)
    if block_given?
      my_each { |item| return false if yield(item) }
      true
    elsif arg.is_a?(Class)
      my_each { |item| return false if item.class == arg }
      true
    elsif arg.class == Regexp
      my_each { |item| return false if arg.match(item) }
    elsif self.length.zero? || self.nil?
      true
    elsif !block_given? && arg.nil?
      my_any? { |item| return false if item == true }
      my_each { |item| return true if item.nil? || item == false }
    else
      my_each { |item| return false if item == arg }
    end
    true
  end

  def my_count(num = nil)
    chars = 0

    if block_given?
      my_each { |item| chars += 1 if yield(item) }
    elsif num
      my_each { |item| chars += 1 if item == num }
    else
      my_each { chars += 1 }
    end
    chars
  end

  def my_map(arg = nil)
    return enum_for(:my_map) unless block_given? || arg

    new_arr = []
    if arg
      my_each { |item| new_arr.push(new_arg.call(item)) }
    else
      my_each { |item| new_arr.push(yield(item)) }
    end
    new_arr
  end

  def my_inject(arg = nil, sym = nil)
    if (arg.is_a?(Symbol) || arg.is_a?(String)) && (!arg.nil? && sym.nil?)
      sym = arg
      arg = nil
    end

    if !block_given? && !sym.nil?
      my_each { |item| arg = arg.nil? ? item : arg.send(sym, item) }
    else
      my_each { |item| arg = arg.nil? ? item : yield(arg, item) }
    end
    arg
  end
end

def multiply_els(list)
  list.my_inject(:*)
end


=begin
#my_each test
[1, 2, 3, 5].my_each { |x| p x }
puts
[1, 2, 3, 5].each { |x| p x } #compare
puts

#my_each_with_index test
[1, 2, 3, 5].my_each_with_index { |x, y| puts "#{x} at #{y}" }
puts
[1, 2, 3, 5].each_with_index { |x, y| puts "#{x} at #{y}" }#compare
puts

#my_select test
p [1, 2, 3, 4].my_select { |x| x % 2 == 0}
puts
p [1, 2, 3, 4].select { |x| x % 2 == 0 }#compare
puts
p (1..10).my_select { |i|  i % 3 == 0 }   #=> [3, 6, 9]
puts
p (1..10).select { |i|  i % 3 == 0 }   #=> [3, 6, 9]
puts
p [1,2,3,4,5].my_select { |num|  num.even?  }   #=> [2, 4]
puts
p [1,2,3,4,5].select { |num|  num.even?  }   #=> [2, 4]
puts
p [:foo, :bar].my_select { |x| x == :foo }   #=> [:foo]
puts
p [:foo, :bar].select { |x| x == :foo }   #=> [:foo]
puts

#my_all? test
p ['alpha', 'apple', 'allen key'].my_all?{ |x| x[0] == 'a' }
puts
p ['alpha', 'apple', 'allen key'].all?{ |x| x[0] == 'a' }
puts
p %w[ant bear cat].my_all? { |word| word.length >= 4 } #=> false
puts
p %w[ant bear cat].all? { |word| word.length >= 4 } #=> false
puts
p %w[ant bear cat].my_all?(/t/)                        #=> false
puts
p %w[ant bear cat].all?(/t/)                        #=> false
puts
p [1, 2i, 3.14].my_all?(Numeric)                       #=> true
puts
p [1, 2i, 3.14].all?(Numeric)                       #=> true
puts
p [nil, true, 99].my_all?                              #=> false
puts
p [nil, true, 99].all?                              #=> false
puts
p [].my_all?                                           #=> true
puts
p [].all?                                           #=> true
puts

#my_any? test
p ['lpha', 'apple', 'llen key'].my_any?{ |x| x[0] == 'a' }
puts
p ['lpha', 'pple', 'allen key'].any?{ |x| x[0] == 'a' }
puts
p %w[ant bear cat].my_any? { |word| word.length >= 3 } #=> true
puts
p %w[ant bear cat].any? { |word| word.length >= 3 } #=> true
puts
p %w[ant bear cat].my_any? { |word| word.length >= 4 } #=> true
puts
p %w[ant bear cat].any? { |word| word.length >= 4 } #=> true
puts
p %w[ant bear cat].my_any?(/d/)                        #=> false
puts
p %w[ant bear cat].any?(/d/)                        #=> false
puts
p [nil, true, 99].my_any?(Integer)                     #=> true
puts
p [nil, true, 99].any?(Integer)                     #=> true
puts
p [nil, true, 99].my_any?                              #=> true
puts
p [nil, true, 99].any?                              #=> true
puts
p [].my_any?                                           #=> false
puts
p [].any?                                           #=> false
puts

#my_none? test
p ['lpha', 'pple', 'llen key'].my_none?{ |x| x[0] == 'a' }
puts
p ['lpha', 'pple', 'llen key'].none?{ |x| x[0] == 'a' }
puts
class DeathCab
end
plans = DeathCab.new()
p [1, 3.14, 42].my_none?(Float)  # => output false
puts
p [1, 3.14, 42].none?(Float)  # => output false
puts
p ["BY" "FIRE" "BE" "PURGED", %w[DIE INSECT].to_enum].my_none?(Numeric)  # => output false
puts
p ["BY" "FIRE" "BE" "PURGED", %w[DIE INSECT].to_enum].none?(Numeric)  # => output false
puts
p ["With", "eyes", "like", "the", "summer", 3].my_none?(Float)  # => output true
puts
p ["With", "eyes", "like", "the", "summer", 3].none?(Float)  # => output true
puts
p [1.12, 3.14, 3.15].my_none?(String)  # => output true
puts
p [1.12, 3.14, 3.15].none?(String)  # => output true
puts
p [plans, plans, plans].my_none?(DeathCab)  # => output false
puts
p [plans, plans, plans].none?(DeathCab)  # => output false
puts

#my_count test
arr = [1, 2, 3, 4]
p arr.my_count { |i| i%2==0}
puts
p arr.count { |i| i%2==0}
puts
p arr.my_count               # => 4
puts
p arr.count               # => 4
puts
p arr.my_count(2)            # => 1
puts
p arr.count(2)            # => 1
puts
p [1,2,3,4,4,7,7,7,9].my_count { |i| i > 1 }
puts
p [1,2,3,4,4,7,7,7,9].count { |i| i > 1 }
puts

#my_map test
p [1,2,3,4,4,7,7,7,9].my_map { |i| i*4 }
puts
p [1,2,3,4,4,7,7,7,9].map { |i| i*4 }
puts
p (1..4).my_map { |i| i*i }
puts
p (1..4).map { |i| i*i }
puts
p (1..4).my_map { "cat"  }
puts
p (1..4).map { "cat"  }
puts

#my_inject test
p [1,2,3,4,4,7,7,7,9].my_inject(0){|running_total, item| running_total + item }
puts
p [1,2,3,4,4,7,7,7,9].inject(0){|running_total, item| running_total + item }
puts
p (5..10).my_inject(:+)
puts
p (5..10).inject(:+)
puts
p (5..10).my_inject { |sum, n| sum + n }
puts
p (5..10).inject { |sum, n| sum + n }
puts
p (5..10).my_inject(1, :*)
puts
p (5..10).inject(1, :*)
puts
p (5..10).my_inject(1) { |product, n| product * n }
puts
p (5..10).inject(1) { |product, n| product * n }
puts
p [2,4,5].my_inject(:*) #POINT NUMBER 10
puts
p [2,4,5].inject(:*) #POINT NUMBER 10
puts
longest = %w{ cat sheep bear }.my_inject do |memo, word|
 memo.length > word.length ? memo : word
end
puts longest
puts
longest = %w{ cat sheep bear }.inject do |memo, word|
 memo.length > word.length ? memo : word
end
puts longest
=end

# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Style/RedundantSelf
