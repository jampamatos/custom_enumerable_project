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

  def my_inject(initial = first, sym = nil)
    memo = initial

    enum = to_a

    if block_given?
      enum.my_each_with_index do |el, idx|
        next if memo == first && idx.zero?

        memo = yield memo, el
      end
    else
      block = sym.to_proc
      enum.my_each_with_index do |el, idx|
        next if memo == first && idx.zero?

        memo = block.call memo, el
      end
    end
    memo
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  def my_each(&proc)
    return to_enum(:my_each) unless block_given?

    for i in self
      proc.call(i)
    end
    self
  end
end

# Same using a block and inject
puts ((5..10).my_inject { |sum, n| sum + n })
#=> 45

# Same using a block
puts ((5..10).my_inject(1) { |product, n| product * n })
#=> 151200

# find the longest word
longest = %w[cat sheep bear].inject do |memo, word|
  memo.length > word.length ? memo : word
end
puts longest
#=> "sheep"

###########################

# WITH SYMBOLS

# Sum some numbers
#puts ((5..10).my_inject(:+))
# => 45

# Multiply some numbers
puts ((5..10).my_inject(1, :*))
# => 151200
