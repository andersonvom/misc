spacing = 2;
tile_width = 10;
length = tile_width + spacing;
num_tiles = [50, 50];
canvas_size = [ num_tiles[0]*(tile_width+spacing)+1.5*spacing, num_tiles[1]*(tile_width+spacing)+1.5*spacing ];
background_color = 200;
mouse_start_x = 0;
mouse_start_y = 0;
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

void draw(){
	background(background_color);
	var cells = board.get_cells();
	for (var i=0; i<num_tiles[0]; i++) {
		for (var j=0; j<num_tiles[1]; j++) {
			cell = cells[i][j];
			if (cell.is_alive()) fill(255,0,0);
			else fill(255);

			rect(i*length+spacing, j*length+spacing, tile_width, tile_width);
		}
	}
	
	fill(255,255,0);
	var x = (int)((mouseX - 1) / length);
	var y = (int)((mouseY - 1) / length);
	rect(x*length+spacing, y*length+spacing, tile_width, tile_width);
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
}

void mouseDragged()
{
	var x = (int)((mouseX - 1) / length);
	var y = (int)((mouseY - 1) / length);
	var cells = board.get_cells();
	if (cells[mouse_start_x][mouse_start_y].is_alive()) {
		if (!cells[x][y].is_alive())
			board.toggle_cell(x,y);
	}
	else {
		if (cells[x][y].is_alive())
			board.toggle_cell(x,y);
	}
}
