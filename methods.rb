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
    my_each { |element| sel_arr.push(element) if yield(element) }
    sel_arr
  end

end

# rubocop:enable Style/CaseEquality