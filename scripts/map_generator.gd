extends Node2D


export var floor_dimensions = Vector2(16, 10)
export var mid_density = 7
export var is_generative = false
export var tile_size = Vector2(32, 32)

var all_map_pos = []
var visible_pos = []

# Called when the node enters the scene tree for the first time.
func _ready():
	if is_generative:
		gen_random_map()
		
		
	#gen all dungeon tile positions
	for y in floor_dimensions.y:
		for x in floor_dimensions.x:
			var map_coord = Vector2(x, y)
			if not $TileMap.get_cellv(map_coord) == -1:
				all_map_pos.append(map_coord)
		
	#draw occluders for all vent tiles
	for map_coord in all_map_pos:
		if $TileMap.get_cellv(map_coord) == 3:
			var world_coords = $TileMap.map_to_world(map_coord)
			var new_occluder = LightOccluder2D.new()
			var new_occluder_poly = OccluderPolygon2D.new()
			
			new_occluder_poly.polygon = PoolVector2Array([world_coords + Vector2(0, 0), 
			world_coords + Vector2(0, 16), 
			world_coords + Vector2(4, 16), 
			world_coords + Vector2(4, 0)])				
			new_occluder.occluder = new_occluder_poly
			$CutomOccluders.add_child(new_occluder)
			
			
			new_occluder = LightOccluder2D.new()
			new_occluder_poly = OccluderPolygon2D.new()
			new_occluder_poly.polygon = PoolVector2Array([world_coords + Vector2(12, 0), 
			world_coords + Vector2(12, 16), 
			world_coords + Vector2(20, 16), 
			world_coords + Vector2(20, 0)])				
			new_occluder.occluder = new_occluder_poly
			$CutomOccluders.add_child(new_occluder)
			
			
			new_occluder = LightOccluder2D.new()
			new_occluder_poly = OccluderPolygon2D.new()
			new_occluder_poly.polygon = PoolVector2Array([world_coords + Vector2(32, 0), 
			world_coords + Vector2(32, 16), 
			world_coords + Vector2(28, 16), 
			world_coords + Vector2(28, 0)])				
			new_occluder.occluder = new_occluder_poly
			$CutomOccluders.add_child(new_occluder)
		
		
			
		

func gen_random_map():
	randomize()
	$TileMap.clear()
	for y in floor_dimensions.y:
		for x in floor_dimensions.x:
			if y == 0 or y == floor_dimensions.y - 1 or x == 0 or x == floor_dimensions.x - 1:
				$TileMap.set_cell(x, y, 1)
			else:
				$TileMap.set_cell(x, y, clamp(randi() % mid_density - (mid_density - 2), 0, 1))
	
