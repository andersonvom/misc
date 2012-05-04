function Cell()
{
  this.next_status = 0;
  this.current_status = 0;

  // Constants
  this.DEAD   = 0;
  this.ALIVE  = 1;
  
  this.DEAD_SYMBOL = 'b';
  this.ALIVE_SYMBOL = 'o';

  this.init = function(status)
  {
    if (status == undefined) status = this.DEAD;
    this.current_status = status;
  }

  this.state = function()
  {
    if (this.is_alive()) return this.ALIVE_SYMBOL;
    else return this.DEAD_SYMBOL;
  }
  
  this.is_alive = function()
  {
    return (this.current_status == this.ALIVE);
  }

  this.starve = function()
  {
    this.next_status = this.DEAD;
  }

  this.overpopulate = function()
  {
    this.next_status = this.DEAD;
  }

  this.keep_alive = function()
  {
    this.next_status = this.ALIVE;
  }

  this.flourish = function()
  {
    this.next_status = this.ALIVE;
  }
  
  this.toggle = function()
  {
    if (this.current_status == this.ALIVE) this.next_status = this.DEAD;
    else this.next_status = this.ALIVE;
    this.update();
    
    return this;
  }

  this.update = function()
  {
    this.current_status = this.next_status
    this.next_status = undefined;

    return this;
  }

  this.tick = function(live_neighbors)
  {
    var changed = false;

    if (this.is_alive())
    {
      switch(live_neighbors)
      {
        case 0:
        case 1:
          changed = true;
          this.starve();
          break;

        case 2:
        case 3:
          this.keep_alive();
          break;

        default:
          changed = true;
          this.overpopulate();
          break;
      }
    }
    else
    {
      if (live_neighbors == 3) {
        changed = true;
        this.flourish();
      }
    }

    return changed;
  }

}

function Board()
{
  this.rows = 0;
  this.columns = 0;
  this.cells = new Array();
  this.runner = undefined;
  this.speed = 200;
  this.changed_cells = [];

  this.init = function(rows, columns)
  {
    this.rows = rows;
    this.columns = columns;
    this.fill_cells();
  }
  
  this.get_cells = function()
  {
    return this.cells;
  }
  
  this.get_changed_cells = function(clear)
  {
    var cell_positions = this.changed_cells;
    if (clear)
      this.changed_cells = [];
    return cell_positions;
  }

  this.fill_cells = function(status)
  {
    this.cells = new Array(this.rows);
    for (var row=0 ; row<this.rows ; row++) {
      this.cells[row] = new Array(this.columns);
      for (var col=0 ; col<this.columns ; col++) {
        var new_cell = new Cell();
        new_cell.init(status);
        this.cells[row][col] = new_cell; // TODO: add other types of filling
        this.changed_cells.push([row,col]);
      }
    }
  }
  
  this.toggle_cell = function(row, col)
  {
    this.cells[row][col].toggle();
    this.changed_cells.push([row,col]);
    return this;
  }

  this.tick = function()
  {
    var changed = false;
    var cell_status = false;

    for (var row=0 ; row<this.rows ; row++) {
      for (var col=0 ; col<this.columns ; col++) {
        cell_status = this.cells[row][col].tick( this.neighbors(row, col) );
        if (cell_status) this.changed_cells.push([row,col]);
        changed = changed || cell_status;
      }
    }

    if (!changed) {
      this.stop();
      return;
    }

    for (var row=0 ; row<this.rows ; row++) {
      for (var col=0 ; col<this.columns ; col++) {
        this.cells[row][col].update();
      }
    }
  }

  this.neighbors = function(row, col)
  {
    var live_neighbors = 0;
    var min_row = (row-1<0) ? this.rows-1 : row-1;
    var min_col = (col-1<0) ? this.columns-1 : col-1;

    for (var i=0 ; i<3 ; i++) {
      r = (min_row + i) % this.rows;
      for (var j=0 ; j<3 ; j++) {
        c = (min_col + j) % this.columns;
        if ( ((r!=row) || (c!=col)) && this.cells[r][c].is_alive() ) {
          live_neighbors += 1;
        }
      }
    }
    return live_neighbors;
  }

  this.num_live_cells = function()
  {
    var live_cells = 0;
    for (var row=0 ; row<this.rows ; row++) {
      for (var col=0 ; col<this.columns ; col++) {
        if (this.cells[row][col].is_alive()) live_cells++;
      }
    }
    return live_cells;
  }

  this.step = function()
  {
    this.tick();
  }

  this.run = function()
  {
    var board = this;
    this.tick();
    if (this.runner == undefined)
      this.runner = setInterval(function(){board.step();}, this.speed);
  }
  
  this.change_speed = function(value)
  {
    if (value == 0)
      this.speed = 200;
    else {
      // Invert values because the longer the timer, the slower the speed
      value *= -1;
      value += 1;
      
      this.speed = Math.ceil(this.speed * value);
      if (this.speed < 25) this.speed = 25;
      if (this.runner != undefined) {
        clearTimeout(this.runner);
        this.runner = setInterval(function(){board.step();}, this.speed);
      }
    }
    return this.speed;
  }

  this.stop = function()
  {
    clearTimeout(this.runner);
    this.runner = undefined;
  }

  this.rle_encode = function()
  {
    var rle = new RLE();
    return rle.encode( this.states() );
  }

  this.rle_decode = function(str)
  {
    this.fill_cells(0);
    if (str == null || str == undefined || str == "") return;
    
    var rle = new RLE();
    var stream = rle.decode( str );
    
    var i = -1;
    last_char:
    for (var row=0 ; row<this.rows ; row++) {
      end_line:
      for (var col=0 ; col<this.columns ; col++) {
        i++;
        if (stream[i] == '$') break end_line;
        if (stream[i] == '!' || stream[i] == undefined) break last_char;
        var current_state = this.cells[row][col].state();
        if (current_state != stream[i]) this.toggle_cell(row, col);
      }
    }
  }
  
  this.states = function()
  {
    var line = [];
    var states = [];
    for (var row=0 ; row<this.rows ; row++) {
      line = [];
      for (var col=0 ; col<this.columns ; col++) {
        line.push( this.cells[row][col].state() );
      }
      states.push(line.join(''));
    }
    return states;
  }
  
  this.size = function()
  {
    var size = [0,0];
    var upper_left_corner = [this.rows-1,this.columns-1];
    var bottom_right_corner = [0,0];
    
    for (var row=0 ; row<this.rows ; row++) {
      for (var col=0 ; col<this.columns ; col++) {
        if (this.cells[row][col].is_alive()) {
          if (row < upper_left_corner[0]) upper_left_corner[0] = row;
          if (col < upper_left_corner[1]) upper_left_corner[1] = col;
          
          if (row > bottom_right_corner[0]) bottom_right_corner[0] = row;
          if (col > bottom_right_corner[1]) bottom_right_corner[1] = col;
        }
      }
    }
    
    size[0] = bottom_right_corner[0] - upper_left_corner[0] + 1;
    size[1] = bottom_right_corner[1] - upper_left_corner[1] + 1;
    return size.concat(upper_left_corner);
  }
  
  this.center = function()
  {
    var size = this.size();
    var spacing = [size[2], size[3]];
    
    var shift_size = [0,0];
    shift_size[0] = Math.floor( (this.rows - size[0]) / 2 );
    shift_size[1] = Math.floor( (this.columns - size[1]) / 2 );
    
    var encoding = this.rle_encode();
    var tmp_encoding = encoding.replace(/^\$+/,'').split('$');
    for (var i in tmp_encoding) {
      tmp_encoding[i] = this.align_left(tmp_encoding[i], shift_size[1], spacing[1]);
    }
    
    var new_encoding = (new Array(shift_size[0])).join('$') + tmp_encoding.join('$');
    
    if (encoding == new_encoding) return;
    this.rle_decode(new_encoding);
  }
  
  this.align_left = function(line, shift_size, spacing)
  {
    if (shift_size == 0) return line;
    if (shift_size == spacing) return line;
  
    var new_encoding = line;
    var first_dead_run = line.match(/^[0-9]*b/);
    if (first_dead_run != null) first_dead_run = first_dead_run.pop();
    else first_dead_run = "";
    
    if ( first_dead_run.length != 1 ) {
      var tabs = 0;
      var count = parseInt(first_dead_run);
      if (count >= spacing) tabs = count - spacing;
      if (tabs == 1) tabs = "";
      new_encoding = line.replace(/^[0-9]*b/, tabs + "b");
    }
    
    return shift_size + 'b' + new_encoding;
  }
  
}
