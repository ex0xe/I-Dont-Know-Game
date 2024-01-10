extends Camera2D




# Called when the node enters the scene tree for the first time.
func _ready():
	var tile_map = $TileMap  # Replace with the path to your TileMap node
	var map_size_in_tiles = tile_map.get_used_rect().size
	var tile_size = tile_map.cell_size
	var map_pixel_size = map_size_in_tiles * tile_size
	
	limit_left = 0
	limit_top = 0
	limit_right = map_pixel_size.x
	limit_bottom = map_pixel_size.y
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
