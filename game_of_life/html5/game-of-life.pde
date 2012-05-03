spacing = 2;
tile_width = 8;
length = tile_width + spacing;
num_tiles = [50, 50];
canvas_size = [ num_tiles[0]*(tile_width+spacing)+1.5*spacing, num_tiles[1]*(tile_width+spacing)+1.5*spacing ];
background_color = 200;
mouse_start_x = 0;
mouse_start_y = 0;
start_status = false;
board = new Board();

void setup()
{
	size(canvas_size[0], canvas_size[1]);
	fill(255);
	stroke(background_color);
	background(background_color);
	board.init(num_tiles[0],num_tiles[1]);
	
	if (window.location.hash)
	  board.rle_decode(window.location.hash.substring(1));
	else
	  board.fill_cells(0);
}

void reset_board(tiles_x, tiles_y)
{
  num_tiles = [tiles_x, tiles_y];
  canvas_size = [ num_tiles[0]*(tile_width+spacing)+1.5*spacing, num_tiles[1]*(tile_width+spacing)+1.5*spacing ];
  setup();
}

void draw()
{
	var changed_positions = board.get_changed_cells(true);
	if (changed_positions.length > 0)
	{
	  for (var i=0; i<changed_positions.length; i++) {
		  var pos = changed_positions[i];
		  draw_cell(pos[0], pos[1]);
	  }
	  window.location.hash = board.rle_encode();
	}
}

void draw_cell(row, col)
{
	var cells = board.get_cells();
	var cell = cells[row][col];
	
	if (cell.is_alive()) fill(255,0,0);
	else fill(255);
	
	x_position = length*row + spacing;
	y_position = length*col + spacing;
	rect(x_position, y_position, tile_width, tile_width);
}

void mouseClicked()
{
	var x = (int)((mouseX - 1) / length);
	var y = (int)((mouseY - 1) / length);
	board.toggle_cell(x,y);
}

void mousePressed()
{
	mouse_start_x = (int)((mouseX - 1) / length);
	mouse_start_y = (int)((mouseY - 1) / length);
	var cells = board.get_cells();
	start_status = cells[mouse_start_x][mouse_start_y].is_alive()
}

void mouseDragged()
{
	var x = (int)((mouseX - 1) / length);
	var y = (int)((mouseY - 1) / length);
	var cells = board.get_cells();
	if (!start_status) {
		if (!cells[x][y].is_alive())
			board.toggle_cell(x,y);
	}
	else {
		if (cells[x][y].is_alive())
			board.toggle_cell(x,y);
	}
}

void keyPressed()
{
	if (key == 'r') {
		rand();
	}
	else if (key == 'c') {
		clear();
	}
	else if (key == 's') {
		stop();
	}
	else if (key == 'p') {
		play();
	}
	else if (key == 't') {
		step();
	}
	else if (key == '+') {
		speed(0.2);
	}
	else if (key == '-') {
		speed(-0.2);
	}
}

void rand()  { board.change_speed(0); board.fill_cells(); }
void clear() { board.change_speed(0); board.fill_cells(0); }
void stop()  { board.stop(); }
void play()  { board.run(); }
void step()  { board.step(); }
void speed(spd) { board.change_speed(spd); }

