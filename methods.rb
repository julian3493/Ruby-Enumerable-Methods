# rubocop:disable Style/CaseEquality

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    list = to_a if self.class == Range || Hash

    for i in 0..list.length
      yield(list[i])
    end
    self
  end

  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    list = to_a if self.class == Range || Hash
    
    for i in 0..list.length
      yield(list[i], i)
    end
    self
  end

  def my_select
    return to_enum(:my_select) unless block_given?

    sel_arr = []
    my_each { |element| sel_arr.push(element) if yield(element) }
    sel_arr
  end

  def my_all?(*arg)
    if block_given?
      my_each { |item| return false if yield(item) == false}
      true
    elsif arg.nil?
      my_each { |item| return false if item.nil? }
    elsif !arg.nil? and arg.is_a?(Class)
      my_each { |item| return false unless [item.class].include?(arg) }
    elsif arg.class == Regexp
      my_each { |item| return false unless arg.match(item) }
    else my_each { |item| return false if item != arg }
    end
    true
  end

  def my_any?(*arg)
    if block_given?
      my_each { |item| return true if yield(item)}
    elsif arg.nil?
      my_each { |item| return true if item }
    elsif !arg.nil? and arg.is_a?(Class)
      my_each { |item| return true if [item.class].include?(arg) }
    elsif arg.class == Regexp
      my_each { |item| return true if arg.match(item) }
    else my_each { |item| return true if item == arg }
    end
    false
  end

  def my_none?(*arg)
    if block_given?
      my_each { |element| return false if yield(element) }
      true
    elsif arg.is_a?(Class)
      my_each { |element| return false if element.class == arg }
      true
    elsif arg.class == Regexp
      my_each { |element| return false if arg.match(element) }
    elsif self.length.zero? || self.nil?
      true
    elsif !block_given? && arg.nil?
      my_any? { |element| return false if element == true }
      my_each { |element| return true if element.nil? || element == false }
    else
      my_each { |element| return false if element == arg }
    end
    true
  end

  def my_count(num = nil)
    chars = 0

    if block_given?
      my_each { |item| chars += 1 if yield(item)}
    elsif num
      my_each { |item| counter += 1 if item == num}
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


end

# rubocop:enable Style/CaseEquality
