class Sudoku

  attr_accessor :raw_entry, :squares, :values, :unit_list, :units, :peers

  WIDTH = 10
  DIGITS = %w( 1 2 3 4 5 6 7 8 9 )
  ROWS = %w( A B C D E F G H I )
  COLS = DIGITS.clone

  def initialize(raw_entry)
    self.raw_entry = raw_entry

    self.unit_list  = ROWS.map { |r| COLS.map { |c| r+c } }
    self.unit_list += COLS.map { |c| ROWS.map { |r| r+c } }
    3.times do |ri|
      3.times do |ci|
        self.unit_list << ROWS[3*ri, 3].map { |r| COLS[3*ci, 3].map { |c| r+c } }.flatten
      end
    end

    self.squares = self.unit_list.flatten.uniq.sort
    self.units   = Hash.new []
    self.peers   = Hash.new []
    self.values  = Hash.new

    self.squares.each do |square|
      self.values[square] = DIGITS.join
      self.unit_list.each do |unit|
        if unit.include? square
          self.units[square] += unit
          self.peers[square] += (unit - [square])
        end
      end
    end
  end

  def parse
    display
    grid = Hash[self.squares.zip self.raw_entry.chars.to_a]
    grid.each do |key, value|
      assign(key, value) if value =~ /[1-9]/
    end
    nil
  end

  def assign(square, value)
    other_values = self.values[square].gsub value, ''

    contradiction = false
    other_values.chars { |other_value| contradiction |= !eliminate(square, other_value) }
    !contradiction
  end

  def eliminate(square, value)
    return true unless self.values[square].include? value # already eliminated

    self.values[square].gsub! value, '' # eliminate from given square
    display

    case self.values[square].size
    # If no other possible values exist, then its a contradiction!
    when 0
      return false
    # When only one possible value exists, then remove this value from this square's peers
    when 1
      contradiction = false
      self.peers[square].each { |peer| contradiction |= !eliminate(peer, self.values[square]) }
      return false if contradiction
    end

    # Verify possible places for 'value' after removing it from 'square'
    possible_places = self.units[square].map { |unit| unit if self.values[unit].include? value }.compact
    case possible_places.size
    when 0
      return false # contradiction since there are no more places to put 'value'
    when 1
      return false unless assign(possible_places.first, value)
    end

    true
  end

  def display
    sleep(0.01)
    system "clear"
    line = [ ['-'*(WIDTH*3+1)] * 3 ].join '+'
    ROWS.each do |r|
      row = []
      COLS.each do |c|
        row << (self.values[r+c] || '123456789').center(DIGITS.size)
        row << '|' if c =~ /[36]/
      end
      puts ' ' + row.join(' ')
      puts line if r =~ /[CF]/
    end
    nil
  end

end
