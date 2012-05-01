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
	board.fill_cells(0);
}

void draw()
{
	var changed_positions = board.get_changed_cells(true);
	for (var i=0; i<changed_positions.length; i++) {
		var pos = changed_positions[i];
		draw_cell(pos[0], pos[1]);
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
		board.change_speed(0);
		board.fill_cells();
	}
	else if (key == 'c') {
		board.change_speed(0);
		board.fill_cells(0);
	}
	else if (key == 's') {
		board.stop();
	}
	else if (key == 'p') {
		board.run();
	}
	else if (key == 't') {
		board.step();
	}
	else if (key == '+') {
		board.change_speed(0.2);
	}
	else if (key == '-') {
		board.change_speed(-0.2);
	}
}
