require 'cell'

describe Cell do

  before do
    @cell = Cell.new
  end

  subject { @cell }

  specify { should respond_to :current_status }
  specify { should respond_to :next_status }

  its(:next_status) { should be_nil }
  its(:current_status) { should match Regexp.new "[#{Cell::DEAD}#{Cell::ALIVE}]" }
  it { Cell.new(Cell::ALIVE).should be_alive }

  it "should starve" do
    @cell.starve.next_status.should eql Cell::DEAD
  end

  it "should overpopulate" do
    @cell.overpopulate.next_status.should eql Cell::DEAD
  end

  it "should flourish" do
    @cell.flourish.next_status.should eql Cell::ALIVE
  end

  it "should stay alive" do
    @cell.keep_alive.next_status.should eql Cell::ALIVE
  end

  it "should update next status" do
    @cell.current_status = Cell::DEAD
    @cell.next_status = Cell::ALIVE
    @cell.update
    @cell.should be_alive
    @cell.next_status.should be_nil
  end

  it "should output status to string" do
    @cell.current_status = Cell::DEAD
    @cell.to_s.should eql Cell::DEAD
    @cell.current_status = Cell::ALIVE
    @cell.to_s.should eql Cell::ALIVE
  end

  context "when alive #" do
    before do
      @cell.current_status = Cell::ALIVE
      @dead_cell = Cell.new Cell::DEAD
      @live_cell = Cell.new Cell::ALIVE
    end

    its(:alive?) { should be_true }

    it "should starve if there are too few neighbors" do
      @cell.tick [@dead_cell,@dead_cell,@dead_cell,@dead_cell]
      @cell.update
      @cell.should_not be_alive
      @cell.tick [@live_cell,@dead_cell,@dead_cell,@dead_cell]
      @cell.update
      @cell.should_not be_alive
    end

    it "should starve if overpopulating" do
      @cell.tick [@live_cell,@live_cell,@live_cell,@live_cell]
      @cell.update
      @cell.should_not be_alive
    end

    it "should stay alive if there are enough neighbors" do
      @cell.tick [@live_cell,@live_cell,@dead_cell,@dead_cell]
      @cell.update
      @cell.should be_alive
      @cell.tick [@live_cell,@live_cell,@live_cell,@dead_cell]
      @cell.update
      @cell.should be_alive
    end

  end

  context "when dead #" do
    before do
      @cell.current_status = Cell::DEAD
      @dead_cell = Cell.new Cell::DEAD
      @live_cell = Cell.new Cell::ALIVE
    end

    its(:alive?) { should be_false }

    it "should flourish if there are enough neighbors" do
      @cell.tick [@live_cell,@live_cell,@live_cell,@dead_cell]
      @cell.update
      @cell.should be_alive
    end
  end

end
