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
      my_each { |element| return false if element.nil? }
    elsif !arg.nil? and arg.is_a?(Class)
      my_each { |element| return false unless [element.class].include?(arg) }
    elsif arg.class == Regexp
      my_each { |element| return false unless arg.match(element) }
    else my_each { |element| return false if element != arg }
    end
    true
  end

  
end

# rubocop:enable Style/CaseEquality