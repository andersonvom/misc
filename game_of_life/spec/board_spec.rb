require 'board'

describe Board do

  before do
    @board = Board.new 10, 10

    @dead_cell = Cell.new Cell::DEAD
    @live_cell = Cell.new Cell::ALIVE
  end

  subject { @board }

  specify { should respond_to :rows }
  specify { should respond_to :columns }
  specify { should respond_to :cells }

  its(:rows) { should_not be_nil }
  its(:columns) { should_not be_nil }
  its(:cells) { should_not be_empty }

  it "should fill all cells with dead cells" do
    @board.fill_cells @dead_cell
    @board.num_live_cells.should eql 0
  end

  it "should have non-empty cells" do
    @board.rows.times do |row|
      @board.columns.times do |col|
        @board.cells[row][col].should be_a_kind_of Cell
      end
    end
  end

  it "should output the board to string" do
    @board.to_s.gsub(/[-* ]/, "").strip.should eql ""
  end

  it "should find all neighbors of a given cell" do
    @board.fill_cells @live_cell
    @board.cells[0][0] = @dead_cell.dup
    @board.neighbors(0, 0).size.should be_eql 8
    @board.neighbors(0, 0).each { |n| n.should be_alive }
  end

  it "should kill each cell with one or no neighbors, as if by loneliness" do
    @board.fill_cells @dead_cell
    @board.cells[0][0] = @live_cell.dup
    @board.cells[2][2] = @live_cell.dup
    @board.cells[2][3] = @live_cell.dup

    @board.tick
    @board.to_s.gsub(/[- \n]/, "").strip.should eql ""
  end

  it "should kill each cell with four or more neighbors, as if by overpopulation" do
    @board.fill_cells @live_cell

    @board.tick
    @board.to_s.gsub(/[- \n]/, "").strip.should eql ""
  end

  it "should keep alive each cell with two or three neighbors" do
    @board.fill_cells @dead_cell

    @board.cells[0][0] = @live_cell.dup
    @board.cells[0][1] = @live_cell.dup
    @board.cells[1][0] = @live_cell.dup

    @board.tick
    @board.to_s.gsub(/[- \n]/, "").strip.should eql "****"
  end

  it "should ressurect each cell with three neighbors" do
    @board.fill_cells @dead_cell

    @board.cells[0][0] = @live_cell.dup
    @board.cells[0][1] = @live_cell.dup
    @board.cells[0][2] = @live_cell.dup

    @board.tick
    @board.to_s.gsub(/[- \n]/, "").strip.should eql "***"
  end

end
