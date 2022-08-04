module Enumerable
  def my_each_with_index
    return to_enum(:my_each_with_index) unless block_given?

    i = 0
    my_each do |el|
      yield el, i
      i += 1
    end
    self
  end

  def my_select
    return to_enum(:my_each_with_index) unless block_given?

    result = []
    my_each do |el|
      result << el if yield el
    end
    result
  end

  def my_all?(&block)
    block = block_given? ? block : ->(obj) { obj }
    my_each do |el|
      return false unless block.call el
    end
    true
  end

  def my_any?(&block)
    block = block_given? ? block : ->(obj) { obj }
    my_each do |el|
      return true if block.call el
    end
    false
  end

  def my_none?(&block)
    block = block_given? ? block : ->(obj) { obj }
    my_each do |el|
      return false if block.call el
    end
    true
  end

  def my_count(arg = nil)
    count = 0
    my_each do |el|
      if block_given?
        count += 1 if yield el
      elsif arg
        count += 1 if el == arg
      else
        count = size
      end
    end
    count
  end

  def my_map
    return to_enum(:my_each_with_index) unless block_given?

    result = []
    my_each do |el|
      enum = yield el
      result << enum
    end
    result
  end

  def my_inject(acc = nil, sym = nil)
    sym, acc = acc, nil if acc && !sym && !block_given?

    my_each do |el|
      if !acc
        acc = el
      elsif sym
        acc = acc.send(sym, el)
      else
        acc = yield acc, el
      end
    end
    acc
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  def my_each(&proc)
    return to_enum(:my_each) unless block_given?

    enum = to_a

    for i in enum
      proc.call(i)
    end
    enum
  end
end