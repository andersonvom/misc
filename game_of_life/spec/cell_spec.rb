require 'cell'

describe Cell do

  before do
    @cell = Cell.new
  end

  subject { @cell }

  specify { should respond_to :current_status }
  specify { should respond_to :next_status }

  its(:next_status) { should be_nil }
  its(:current_status) { should be_a_kind_of Fixnum }
  it { Cell.new(1).should be_alive }

  it "should starve" do
    @cell.starve.next_status.should be_eql 0
  end

  it "should overpopulate" do
    @cell.overpopulate.next_status.should be_eql 0
  end

  it "should flourish" do
    @cell.flourish.next_status.should be_eql 1
  end

  it "should stay alive" do
    @cell.keep_alive.next_status.should be_eql 1
  end

  it "should update next status" do
    @cell.current_status = 0
    @cell.next_status = 1
    @cell.update
    @cell.should be_alive
    @cell.next_status.should be_nil
  end

  context "when alive #" do
    before do
      @cell.current_status = 1
      @dead_cell = Cell.new 0
      @live_cell = Cell.new 1
    end

    its(:alive?) { should be_true }

    it "should starve if there are too few neighbors" do
      @cell.tick [@dead_cell,@dead_cell,@dead_cell,@dead_cell]
      @cell.next_status.should be_eql 0
      @cell.tick [@live_cell,@dead_cell,@dead_cell,@dead_cell]
      @cell.next_status.should be_eql 0
    end

    it "should starve if overpopulating" do
      @cell.tick [@live_cell,@live_cell,@live_cell,@live_cell]
      @cell.next_status.should be_eql 0
    end

    it "should stay alive if there are enough neighbors" do
      @cell.tick [@live_cell,@live_cell,@dead_cell,@dead_cell]
      @cell.next_status.should be_eql 1
      @cell.tick [@live_cell,@live_cell,@live_cell,@dead_cell]
      @cell.next_status.should be_eql 1
    end

  end

  context "when dead #" do
    before do
      @cell.current_status = 0
      @dead_cell = Cell.new 0
      @live_cell = Cell.new 1
    end

    its(:alive?) { should be_false }

    it "should flourish if there are enough neighbors" do
      @cell.tick [@live_cell,@live_cell,@live_cell,@dead_cell]
      @cell.next_status.should be_eql 1
    end

  end

end
