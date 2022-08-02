module Enumerable
  def my_each_with_index(&proc)
    self
  end
end

# You will first have to define my_each
# on the Array class. Methods defined in
# your enumerable module will have access
# to this method
class Array
  def my_each(&proc)
    for i in self
      proc.call(i)
    end
    self
  end
end

a = [1,2,3,4]
a.each { |el| puts el }
a.my_each { |el| puts el }