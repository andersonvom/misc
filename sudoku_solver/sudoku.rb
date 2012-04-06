class Sudoku

  attr_accessor :raw_entry, :squares, :values, :unit_list, :units, :peers

  WIDTH = 10
  ROWS = %w( A B C D E F G H I )
  COLS = %w( 1 2 3 4 5 6 7 8 9 )

  def initialize(raw_entry)
    self.raw_entry = raw_entry

    self.unit_list  = ROWS.map { |r| COLS.map { |c| r+c } }
    self.unit_list += COLS.map { |c| ROWS.map { |r| r+c } }
    3.times do |ri|
      3.times do |ci|
        self.unit_list << ROWS[3*ri, 3].map { |r| COLS[3*ci, 3].map { |c| r+c } }.flatten
      end
    end

    self.squares = self.unit_list.flatten.uniq
    self.units   = {}
    self.peers   = {}
    self.values  = {}

    self.squares.each do |square|
      self.units[square] ||= []
      self.peers[square] ||= []
      self.unit_list.each do |unit|
        if unit.include? square
          self.units[square] += unit
          self.peers[square] += (unit - [square])
        end
      end
    end
  end

  def display
    line = [ ['-'*(WIDTH*3+1)] * 3 ].join '+'
    ROWS.each do |r|
      row = []
      COLS.each do |c|
        row << '123412344' # self.values[r+c] || '123456789'
        row << '|' if c =~ /[36]/
      end
      puts ' ' + row.join(' ')
      puts line if r =~ /[CF]/
    end
  end

end
