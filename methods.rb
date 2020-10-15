# rubocop:disable Style/CaseEquality

module Enumerable
  def my_each
    return to_enum(:my_each) unless block_given?

    list = to_a if self.class == Range || Hash
    i=0
    while i<list.length
      yield(list[i])
      i += 1
    end
    self
  end
end

# rubocop:enable Style/CaseEquality