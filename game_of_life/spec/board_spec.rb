require 'board'

describe Board do

  before do
    @board = Board.new 10, 10
  end

  subject { @board }

  specify { should respond_to :rows }
  specify { should respond_to :columns }
  specify { should respond_to :cells }

  its(:rows) { should_not be_nil }
  its(:columns) { should_not be_nil }
  its(:cells) { should_not be_empty }

  it "should fill all cells with dead cells" do
    @dead_cell = Cell.new 0
    @board.fill_cells @dead_cell
    @board.num_live_cells.should be_eql 0
  end

  it "should have non-empty cells" do
    @board.rows.times do |row|
      @board.columns.times do |col|
        @board.cells[row][col].should be_a_kind_of Cell
      end
    end
  end

  it "should find all neighbors of a given cell" do
    pending "Verify why dead cell is being selected"
    @live_cell = Cell.new 1
    @dead_cell = Cell.new 0

    @board.fill_cells @live_cell
    @board.cells[1][1] = @dead_cell
    @board.neighbors(1, 1).size.should be_eql 8
    @board.neighbors(1, 1).each { |n| n.should be_alive }
  end

  it "should tick all cells" do
    pending
    @board.tick
  end

end
