function Cell()
{
	this.next_status = 0;
	this.current_status = 0;

	// Constants
	this.DEAD   = 0;
	this.ALIVE  = 1;

	this.init = function(status)
	{
		var init_status = Math.round(Math.random()*1000) % 2;
		this.current_status = (status != undefined) ? status : init_status;
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

}
