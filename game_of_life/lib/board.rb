require 'cell'

class Board

  attr_accessor :rows, :columns, :cells

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @cells = Array.new( @rows, Array.new( @columns, nil ) )
    fill_cells
  end

  def fill_cells(cell = nil)
    @rows.times do |row|
      @columns.times do |col|
        @cells[row][col] = (cell && cell.dup) || Cell.new
      end
    end
  end

  def tick
    @rows.times do |row|
      @columns.times do |col|
        @cells[row][col].tick neighbors(row, col)
      end
    end
  end

  def neighbors(row, col)
    neighbor_cells = []
    ((row-1)..(row+1)).each do |r|
      ((col-1)..(col+1)).each do |c|
        neighbor_cells << cells[r % @rows][c % @columns] if r!=row or c!= col
      end
    end
    neighbor_cells
  end

  def num_live_cells
    live_cells = 0
    @rows.times do |row|
      @columns.times do |col|
        live_cells += 1 if @cells[row][col].alive?
      end
    end
    live_cells
  end

end
