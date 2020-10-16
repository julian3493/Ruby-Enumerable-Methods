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
      my_each { |item| return false if item.nil? || item == false }
    elsif !arg.nil? and arg.is_a?(Class)
      my_each { |item| return false unless [item.class, item.class.superclass].include?(arg) }
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
      my_each { |item| new_arr.push(new_arr.call(item)) }
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

# rubocop:enable Metrics/ModuleLength
# rubocop:enable Metrics/CyclomaticComplexity
# rubocop:enable Metrics/PerceivedComplexity
# rubocop:enable Style/RedundantSelf
