class Cell

  attr_accessor :current_status, :next_status

  def initialize(status = nil)
    @next_status = nil
    @current_status = status || ( rand * 1000 ).to_i % 2
  end

  def alive?
    current_status == 1
  end

  def tick(neighbors = [])
    live_neighbors = 0
    neighbors.each { |n| live_neighbors += 1 if n.alive? }

    if alive?
      case live_neighbors
        when 0,1
          starve
        when 2,3
          keep_alive
        else
          overpopulate
      end
    else
      flourish if live_neighbors == 3
    end
    self
  end

  def starve
    @next_status = 0
    self
  end

  def overpopulate
    @next_status = 0
    self
  end

  def flourish
    @next_status = 1
    self
  end

  def keep_alive
    @next_status = 1
    self
  end

  def update
    @current_status = next_status
    @next_status = nil
    self
  end

end

