class Cell

  DEAD  = "-"
  ALIVE = "*"

  attr_accessor :current_status, :next_status

  def initialize(status = nil)
    @next_status = nil
    init_status = ( rand * 1000 ).to_i % 2
    @current_status = status || ((init_status==1) ? ALIVE : DEAD)
  end

  def alive?
    current_status == ALIVE
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
    @next_status = DEAD
    self
  end

  def overpopulate
    @next_status = DEAD
    self
  end

  def flourish
    @next_status = ALIVE
    self
  end

  def keep_alive
    @next_status = ALIVE
    self
  end

  def update
    @current_status = next_status
    @next_status = nil
    self
  end

  def to_s
    @current_status.to_s
  end

end

