function Cell()
{
	this.next_status = 0;
	this.current_status = 0;

	// Constants
	this.DEAD   = 0;
	this.ALIVE  = 1;
	this.WIDTH  = 2;
	this.HEIGHT = 2;
	this.LIVE_COLOR  = "rgb(200,0,0)";
	this.DEAD_COLOR  = "rgb(255,255,255)";

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

	this.update = function()
	{
		this.current_status = this.next_status
		this.next_status = undefined;

		return this;
	}

	this.tick = function(neighbors)
	{
		var live_neighbors = 0;
		for (i in neighbors) {
			if (neighbors[i].is_alive()) live_neighbors++;
		}
		
		if (this.is_alive())
		{
			switch(live_neighbors)
			{
				case 0:
				case 1:
					this.starve();
					break;

				case 2:
				case 3:
					this.keep_alive();
					break;

				default:
					this.overpopulate();
					break;
			}
		}
		else
		{
			if (live_neighbors == 3) this.flourish();
		}

		return this;
	}

	this.draw = function(context, pos_x, pos_y)
	{
		context.fillStyle = this.is_alive() ? this.LIVE_COLOR : this.DEAD_COLOR;
		context.fillRect(pos_x, pos_y, this.WIDTH, this.HEIGHT);
	}

}

function Board()
{
	this.rows = 0;
	this.columns = 0;
	this.cells = new Array();

	this.PADDING = 1;

	this.init = function(rows, columns)
	{
		this.rows = rows;
		this.columns = columns;
		this.fill_cells();
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
			}
		}
	}

	this.tick = function()
	{
		for (var row=0 ; row<this.rows ; row++) {
			for (var col=0 ; col<this.columns ; col++) {
				this.cells[row][col].tick( this.neighbors(row, col) );
			}
		}
		for (var row=0 ; row<this.rows ; row++) {
			for (var col=0 ; col<this.columns ; col++) {
				this.cells[row][col].update();
			}
		}
	}

	this.neighbors = function(row, col)
	{
		var min_row = (row-1<0) ? this.rows-1 : row-1;
		var min_col = (col-1<0) ? this.columns-1 : col-1;

		var neighbor_cells = new Array();
		for (var i=0 ; i<3 ; i++) {
			r = (min_row + i) % this.rows;
			for (var j=0 ; j<3 ; j++) {
				c = (min_col + j) % this.columns;
				if ( (r!=row) || (c!=col) ) {
					neighbor_cells.push( this.cells[r][c] );
				}
			}
		}
		return neighbor_cells;
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

	this.step = function(context)
	{
		this.draw(context);
		this.tick();
		this.run(context);
	}

	this.run = function(context)
	{
		this.draw(context);
		this.tick();
		//setTimeout(this.run, 200); // TODO: fix this timeout
	}

	this.stop = function()
	{
		clearTimeout(this.run);
	}

	this.draw = function(context)
	{
		for (var row=0 ; row<this.rows ; row++) {
			for (var col=0 ; col<this.columns ; col++) {
				pos_x = row * (2 + this.PADDING);
				pos_y = col * (2 + this.PADDING);
				this.cells[row][col].draw(context, pos_x, pos_y);
			}
		}
	}

}

