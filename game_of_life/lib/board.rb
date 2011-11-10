class Board

  attr_accessor :rows, :columns, :cells

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    fill_cells
  end

  def fill_cells(cell = nil)
    @cells = Array.new( @rows )

    @rows.times do |row|
      @cells[row] = Array.new( @columns, nil )

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
    @rows.times do |row|
      @columns.times do |col|
        @cells[row][col].update
      end
    end

    self
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

  def run
    begin
      while (true) do
        tick
        puts to_s
        sleep 0.2
        system "clear"
      end
    rescue Exception => e
      puts
      return
    end
  end

  def to_s
    string_board = "\n"
    @rows.times do |row|
      @columns.times do |col|
        string_board += @cells[row][col].to_s
      end
      string_board += "\n"
    end
    string_board
  end

end
