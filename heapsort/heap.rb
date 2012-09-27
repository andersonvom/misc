require 'rspec'

class Heap
  attr_accessor :heap

  def initialize
    self.heap = Array.new
  end

  def sort
    sorted_items = []
    backup_elements = self.heap.dup
    while self.heap.size > 1 do
      sorted_items << self.heap.first
      self.heap[0] = self.heap.pop
      bubble_down self.heap[0]
    end
    sorted_items << self.heap.first
    self.heap = backup_elements
    sorted_items
  end

  def add(elem)
    index = self.heap.size
    self.heap << elem
    bubble_up elem, index
    self
  end

  def bubble_down(elem)
    index = 0
    while true do
      l_child_idx = index * 2 + 1
      r_child_idx = l_child_idx + 1
      return if self.heap[l_child_idx].nil?

      l_elem = self.heap[l_child_idx]
      r_elem = self.heap[r_child_idx]

      lowest_idx = l_child_idx
      lowest_idx = r_child_idx if !r_elem.nil? and r_elem < l_elem

      swap index, lowest_idx if elem > self.heap[lowest_idx]
      index = lowest_idx
    end
  end

  def bubble_up(elem, index)
    parent_idx = (index - 1) / 2
    return if index == 0 or elem >= self.heap[parent_idx]
    
    swap index, parent_idx
    bubble_up elem, parent_idx
  end

  def swap(idx1, idx2)
    temp_elem = self.heap[idx1]
    self.heap[idx1] = self.heap[idx2]
    self.heap[idx2] = temp_elem
  end

  def levels
    levels = [[self.heap[0]]]
    curr_level = 1
    curr_idx = 0
    while curr_idx+1 < self.heap.size do
      next_idx = curr_idx + 2 ** curr_level
      levels << self.heap[(curr_idx+1)..next_idx]
      curr_level += 1
      curr_idx = next_idx
    end
    levels
  end

  def to_a
    self.heap
  end

  def pp
    levels = self.levels
    max_length = self.heap.reduce { |length, elem| [length, elem.to_s.size].max }
    num_levels = levels.size
    levels.each_with_index do |level, index|
      reverse_idx = num_levels - index - 1
      curr_length = (max_length + 1) * (2 ** (index + 1))
      level_str = ""
      levels[reverse_idx].each { |elem| level_str += elem.to_s.center(curr_length)  }
      levels[reverse_idx] = level_str
    end
    "\n" + levels.join("\n")
  end
end

describe "Heap" do
  it "should initialize Heap" do
    Heap.new.to_a.should == []
  end

  it "should add a new element" do
    h = Heap.new
    h.add 10
    h.to_a.should == [10]
  end

  it "should not move elements if in correct order" do 
    h = Heap.new
    h.add 2
    h.add 10
    h.to_a.should == [2,10]
  end

  it "should bubble elements to correct place" do 
    h = Heap.new
    h.add 10
    h.add 2
    h.to_a.should == [2,10]
    h.add 5
    h.to_a.should == [2,10,5]
    h.add 4
    h.to_a.should == [2,4,5,10]
    h.add 3
    h.to_a.should == [2,3,5,10,4]
  end

  it "should bubble elements down correctly" do
    h = Heap.new
    h.heap = [10,1,2]
    h.bubble_down 10
    h.to_a.should == [1,10,2]

    h.heap = [10,2,1,5,6,7,8]
    h.bubble_down 10
    h.to_a.should == [1,2,7,5,6,10,8]
  end

  it "should swap elements correctly" do
    h = Heap.new
    h.add 2
    h.add 10
    h.swap 0,1
    h.to_a.should == [10,2]
  end

  it "should split heap by level" do
    h = Heap.new
    (1..9).each { |i| h.add i }
    h.levels.should == [[1], [2, 3], [4, 5, 6, 7], [8, 9]]
  end

  it "should sort elements correctly" do
    h = Heap.new
    (1..9).to_a.shuffle.each { |i| h.add i }
    h.sort.should == (1..9).to_a
  end

end
